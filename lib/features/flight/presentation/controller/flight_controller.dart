import 'package:final_project/core/navigation/navigation_service.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:final_project/features/flight/data/models/airport.dart';
import 'package:final_project/features/flight/data/models/cheap_flight.dart';
import 'package:final_project/features/flight/data/models/flight_inventory.dart';
import 'package:final_project/features/flight/presentation/state/flight_criteria_state.dart';
import 'package:final_project/features/flight/presentation/state/flight_data_state.dart';
import 'package:final_project/features/flight/presentation/state/flight_ui_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/flight/data/service/listairport_service.dart';
import 'package:final_project/features/flight/data/service/listcheapflight_service.dart';
import 'package:final_project/features/flight/presentation/state/flight_state.dart';
import 'package:intl/intl.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/flight_item.dart';
import '../../data/models/request/flight_booking_request.dart';
import '../../data/service/flight_create_booking_service.dart';
import '../../data/service/flight_service.dart';
import '../screens/flight_results_screen.dart';
import '../state/flight_filter_state.dart';

class FlightController extends ChangeNotifier {
  FlightState _state = FlightState.initial();

  FlightState get state => _state;

  final ListCheapFlightService _cheapFlightService = ListCheapFlightService();
  final ListAirportService _airportService = ListAirportService();
  final FlightService _flightService = FlightService();
  final ScrollController scrollController = ScrollController();
  final FlightBookingService _bookingService = FlightBookingService();

  /// Cuộn màn hình lên vị trí đầu tiên (0.0)
  void scrollToTop() {
    // Kiểm tra xem ScrollController đã được gắn vào ListView/CustomScrollView chưa
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0, // Vị trí mục tiêu (đầu trang)
        duration: const Duration(milliseconds: 500), // Thời gian cuộn (0.5 giây)
        curve: Curves.decelerate, // Hiệu ứng cuộn (nhanh lúc đầu, chậm dần về cuối)
      );
    }
  }

  /// (Tùy chọn) Nếu bạn muốn cuộn ngay lập tức không có hiệu ứng
  void jumpToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }
  }

  void _updateState(FlightState newState) {
    _state = newState;
    notifyListeners();
  }

  // ===== INIT DATA =====
  Future<void> initData() async {
    if (_state.ui.isInitialized) return;
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoading: true)));

    try {
      final token = await TokenService.getToken();
      if (token == null) throw Exception("Token missing");

      final results = await Future.wait([
        _cheapFlightService.fetchListCheapFlight(token),
        _airportService.fetchListAirport(token),
      ]);

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            listCheapFlight: (results[0] as List).cast<CheapFlight>(),
            listAirport: (results[1] as List).cast<Airport>(),
          ),
          ui: _state.ui.copyWith(isLoading: false, isInitialized: true),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ===== SEARCH FLIGHTS =====
  Future<void> fetchFlights(AppLocalizations l10n) async {
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    try {
      final token = await TokenService.getToken();
      final response = await _flightService.fetchFlightInfo(
        startAirport: _state.criteria.departureCode,
        endAirport: _state.criteria.destinationCode,
        startDate: _state.criteria.departureDate,
        returnDate: _state.criteria.returnDate ?? '',
        adults: _state.criteria.adultCount,
        children: _state.criteria.childCount,
        infant: _state.criteria.infantCount,
        typeAirport: _state.criteria.typeAirport,
        token: token!,
      );

      final List<FlightItem> rawGo = response.lsFlightGo ?? [];
      final List<FlightItem> rawReturn = response.lsFlightReturn ?? [];

      // Kiểm tra loại vé dựa trên thuộc tính isMerged của phần tử đầu tiên
      bool isPairType = rawGo.isNotEmpty && rawGo.first.isMerged;

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            internationalFlights: isPairType ? rawGo : [],
            outboundFlights: isPairType ? [] : rawGo,
            returnFlights: isPairType ? [] : rawReturn,
          ),
          ui: _state.ui.copyWith(isLoading: false),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ===== SELECTION LOGIC =====

  // Chọn vé nội địa (từng chặng)
  void selectFlight(
    FlightItem flight,
    FlightInventory inven, {
    required bool isOutbound,
  }) {
    final String? selectedPayload = flight.payload;
    if (isOutbound) {
      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            selectedOutboundFlight: flight.go,
            selectedOutboundInventory: inven,
            payload: selectedPayload,
          ),
          ui: _state.ui.copyWith(
            isViewingReturnFlights: _state.criteria.roundTrip,
          ),
        ),
      );
    } else {
      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            selectedReturnFlight: flight.go,
            selectedReturnInventory: inven,
            payload: selectedPayload,
          ),
        ),
      );
    }
  }

  // Chọn vé quốc tế (bắt cặp đồng hạng)
  void selectInternationalPair(FlightItem pair, {int fareIndex = 0}) {
    final goInvens = pair.go?.inventories ?? [];
    final reInvens = pair.returnFlight?.inventories ?? [];

    if (goInvens.isEmpty) return;

    final selectedGoInv = goInvens[fareIndex];

    // Tìm hạng ghế tương ứng ở chặng về dựa trên FareType
    final selectedReturnInv = reInvens.firstWhere(
      (inv) => inv.fareType == selectedGoInv.fareType,
      orElse: () => reInvens.isNotEmpty ? reInvens.first : FlightInventory(),
    );

    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          selectedInternationalFlight: pair,
          payload: pair.payload,
          selectedOutboundFlight: pair.go,
          selectedReturnFlight: pair.returnFlight,
          selectedOutboundInventory: selectedGoInv,
          selectedReturnInventory: selectedReturnInv,
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====
  void updateTripType(bool isRoundTrip) {
    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          roundTrip: isRoundTrip,
          returnDate: isRoundTrip ? _state.criteria.returnDate : null,
        ),
        data: _state.data.copyWith(
          selectedReturnFlight: null,
          selectedReturnInventory: null,
        ),
      ),
    );
  }

  void backToSearch() {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          outboundFlights: [],
          returnFlights: [],
          internationalFlights: [],
          selectedOutboundFlight: null,
          selectedReturnFlight: null,
          selectedInternationalFlight: null,
        ),
        ui: _state.ui.copyWith(isViewingReturnFlights: false),
      ),
    );
  }

  void updatePassengerData({
    required int adults,
    required int children,
    required int infants,
  }) {
    // Đảm bảo dữ liệu logic: Số trẻ sơ sinh không bao giờ vượt quá số người lớn
    // (Phòng trường hợp logic ở UI có sai sót)
    int validInfants = infants > adults ? adults : infants;

    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          adultCount: adults,
          childCount: children,
          infantCount: validInfants,
        ),
      ),
    );
  }

  List<Airport> filteredAirports(String query) {
    // 1. Làm sạch chuỗi tìm kiếm
    final q = query.toLowerCase().trim();

    // 2. Lấy mã (value) của các sân bay đã được chọn hiện tại
    final String selectedDeparture = _state.criteria.departureAirport.value ?? "";
    final String selectedDestination = _state.criteria.destinationAirport.value ?? "";

    // 3. Tạo danh sách cơ sở đã loại bỏ các sân bay đã chọn
    final baseList = _state.data.listAirport.where((airport) {
      final airportValue = airport.value ?? "";
      // Nếu airportValue rỗng thì vẫn giữ lại, nếu không rỗng thì kiểm tra xem có trùng với chặng đã chọn không
      if (airportValue.isEmpty) return true;

      return airportValue != selectedDeparture && airportValue != selectedDestination;
    });

    // 4. Nếu chuỗi rỗng, trả về danh sách cơ sở đã lọc "trùng"
    if (q.isEmpty) {
      return baseList.toList();
    }

    // 5. Thực hiện lọc theo từ khóa tìm kiếm trên danh sách cơ sở
    return baseList.where((airport) {
      final label = (airport.label ?? "").toLowerCase();
      final value = (airport.value ?? "").toLowerCase();
      final desc = (airport.desc ?? "").toLowerCase();
      final airline = (airport.airline ?? "").toLowerCase();

      return label.contains(q) ||
          value.contains(q) ||
          desc.contains(q) ||
          airline.contains(q);
    }).toList();
  }

  /// Chọn sân bay (Chặng đi hoặc Chặng về)
  void selectAirport({required bool isDeparture, required Airport airport}) {
    // 1. Cập nhật tiêu chí tìm kiếm trong CriteriaState
    final updatedCriteria = isDeparture
        ? _state.criteria.copyWith(departureAirport: airport)
        : _state.criteria.copyWith(destinationAirport: airport);

    // 2. Kiểm tra logic nếu điểm đi trùng điểm đến (Tùy chọn)
    if (updatedCriteria.departureCode == updatedCriteria.destinationCode &&
        updatedCriteria.departureCode.isNotEmpty) {
      _updateState(
        _state.copyWith(
          criteria: updatedCriteria,
          ui: _state.ui.copyWith(
            errorMessage: "Điểm đi và điểm đến không được trùng nhau",
          ),
        ),
      );
      return;
    }

    // 3. Cập nhật State và xóa thông báo lỗi cũ nếu có
    _updateState(
      _state.copyWith(
        criteria: updatedCriteria,
        // Khi đổi sân bay, chúng ta nên xóa danh sách chuyến bay cũ
        // để người dùng không bị nhầm lẫn dữ liệu cũ/mới
        data: _state.data.copyWith(
          outboundFlights: [],
          returnFlights: [],
          internationalFlights: [],
        ),
        ui: _state.ui.copyWith(errorMessage: null),
      ),
    );

    debugPrint(
      ">>> [Flight] Selected ${isDeparture ? 'Departure' : 'Arrival'}: ${airport.value}",
    );
  }

  void resetToInitial() {
    _updateState(
      _state.copyWith(
        // 1. Reset tiêu chí tìm kiếm (Ngày, số khách, điểm đi/đến) về mặc định
        criteria: FlightCriteriaState.initial(),

        // 2. Reset bộ lọc (Hãng bay, số chặng dừng, sắp xếp)
        filter: FlightFilterState.Initial(),

        // 3. Reset dữ liệu chuyến bay ĐÃ TÌM THẤY và CÁC LỰA CHỌN
        // Nhưng GIỮ LẠI listAirport và listCheapFlight (dữ liệu nguồn)
        data: FlightDataState.initial().copyWith(
          listAirport: _state.data.listAirport,
          listCheapFlight: _state.data.listCheapFlight,
        ),

        // 4. Reset trạng thái giao diện
        // GIỮ LẠI isInitialized để initData() không bị gọi lại vô ích
        ui: FlightUiState.initial().copyWith(
          isInitialized: _state.ui.isInitialized,
          isLoading: false, // Đảm bảo không bị kẹt spinner
        ),
      ),
    );

    debugPrint(
      ">>> [Flight] State has been reset to initial (Kept cached airports)",
    );
  }

  void setDate({required bool isReturnDate, required String formattedDate}) {
    final currentCriteria = _state.criteria;

    if (isReturnDate) {
      // 1. CẬP NHẬT NGÀY VỀ
      _updateState(
        _state.copyWith(
          criteria: currentCriteria.copyWith(returnDate: formattedDate),
        ),
      );
    } else {
      // 2. CẬP NHẬT NGÀY ĐI
      // Khi đổi ngày đi, chúng ta cần kiểm tra xem nó có "vượt qua" ngày về hiện tại không
      String? updatedReturnDate = currentCriteria.returnDate;

      if (updatedReturnDate != null) {
        try {
          // Parse ngày để so sánh
          DateTime newDep = DateFormat('dd-MM-yyyy').parse(formattedDate);
          DateTime currentRet = DateFormat(
            'dd-MM-yyyy',
          ).parse(updatedReturnDate);

          // Nếu ngày đi mới sau ngày về hiện tại -> Reset hoặc đẩy ngày về lên cùng ngày đi
          if (newDep.isAfter(currentRet)) {
            updatedReturnDate =
                null; // Hoặc gán = formattedDate tùy UX bạn muốn
          }
        } catch (e) {
          debugPrint("Date Parsing Error: $e");
        }
      }

      _updateState(
        _state.copyWith(
          criteria: currentCriteria.copyWith(
            departureDate: formattedDate,
            returnDate: updatedReturnDate,
          ),
        ),
      );
    }

    debugPrint(
      ">>> [Flight] Set ${isReturnDate ? 'Return' : 'Departure'} Date: $formattedDate",
    );
  }

  void selectFlightTab(FlightTab tab) {
    // 1. Nếu nhấn lại chính Tab đang chọn thì không cần xử lý
    if (_state.ui.selectedFlightTab == tab) return;

    _updateState(_state.copyWith(
      // 2. RESET TIÊU CHÍ TÌM KIẾM (Quan trọng nhất theo yêu cầu của bạn)
      // Điều này sẽ đưa airports về rỗng, ngày về hôm nay, khách về 1 người lớn...
      criteria: FlightCriteriaState.initial(),

      // 3. Cập nhật UI (Chuyển Tab và xóa lỗi)
      ui: _state.ui.copyWith(
        selectedFlightTab: tab,
        errorMessage: null,
        isLoading: false,
      ),

      // 4. RESET DỮ LIỆU KẾT QUẢ VÀ LỰA CHỌN
      data: _state.data.copyWith(
        outboundFlights: [],
        returnFlights: [],
        internationalFlights: [],
        selectedOutboundFlight: null,
        selectedReturnFlight: null,
        selectedInternationalFlight: null,
        selectedOutboundInventory: null,
        selectedReturnInventory: null,
      ),

      // 5. (Bổ sung) Reset cả bộ lọc nếu bạn muốn sạch sẽ hoàn toàn
      filter: FlightFilterState.Initial(),
    ));

    debugPrint(">>> [Flight] Tab switched to ${tab.name} and all search criteria reset.");
  }

  bool navigateToFlightResults(AppLocalizations l10n) {
    final criteria = _state.criteria;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    // 1. KIỂM TRA VALIDATION (Ràng buộc dữ liệu)
    String? error;

    if (criteria.departureCode.isEmpty) {
      error = l10n.errorDepartureEmpty;
    } else if (criteria.destinationCode.isEmpty) {
      error = l10n.errorDestinationEmpty;
    } else if (criteria.departureCode == criteria.destinationCode) {
      error = l10n.errorSameLocation;
    } else if (criteria.roundTrip) {
      // Logic kiểm tra ngày cho vé khứ hồi
      if (criteria.returnDate == null || criteria.returnDate!.isEmpty) {
        error = l10n.errorReturnDateEmpty;
      } else {
        try {
          // Parse ngày từ String sang DateTime để so sánh
          DateTime dep = formatter.parse(criteria.departureDate);
          DateTime ret = formatter.parse(criteria.returnDate!);

          if (dep.isAtSameMomentAs(ret)) {
            // Trường hợp 1: Trùng ngày
            error = l10n.errorSameDate; // Ví dụ: "Ngày đi và ngày về không được trùng nhau"
          } else if (dep.isAfter(ret)) {
            // Trường hợp 2: Ngày đi sau ngày về
            error = l10n.errorReturnBeforeDeparture; // Ví dụ: "Ngày về phải sau ngày đi"
          }
        } catch (e) {
          error = "Định dạng ngày không hợp lệ";
        }
      }
    }
    // Nếu có lỗi, cập nhật state để UI hiển thị thông báo và dừng lại
    if (error != null) {
      _updateState(_state.copyWith(
        ui: _state.ui.copyWith(errorMessage: error),
      ));
      return false;
    }

    // 2. CHUẨN BỊ TRẠNG THÁI TÌM KIẾM
    // Xóa bỏ lỗi cũ và reset danh sách cũ để tránh rác dữ liệu
    _updateState(_state.copyWith(
      ui: _state.ui.copyWith(errorMessage: null),
      data: _state.data.copyWith(
        outboundFlights: [],
        returnFlights: [],
        internationalFlights: [],
      ),
    ));

    // 3. ĐIỀU HƯỚNG SANG TRANG KẾT QUẢ
    // Lưu ý: Việc gọi API fetchFlights nên được thực hiện ở initState của trang kết quả
    // hoặc ngay tại đây trước khi điều hướng tùy vào kiến trúc UX của bạn.
    NavigationService.push(
      MaterialPageRoute(
        builder: (context) => const FlightResultsScreen(),
      ),
    );
    return true;
  }

  void backToSelectOutboundFlights() {
    _updateState(
      _state.copyWith(
        // 1. Cập nhật trạng thái UI
        ui: _state.ui.copyWith(
          isViewingReturnFlights: false, // Tắt chế độ xem chặng về
          errorMessage: null,            // Xóa thông báo lỗi nếu có
        ),

        // 2. Xóa sạch các dữ liệu đã chọn trước đó
        // Khi quay lại chọn chặng đi, chặng về (nếu đã chọn) cũng không còn giá trị
        data: _state.data.copyWith(
          resetOutbound: true, // Xóa sạch chặng đi
          resetReturn: true,   // Xóa luôn chặng về nếu có
          resetIntl: true,     // Xóa quốc tế nếu có
        ),
      ),
    );

    // 3. Cuộn màn hình lên đầu trang để người dùng bắt đầu chọn lại từ đầu danh sách
    scrollToTop();

    debugPrint(">>> [Flight] Navigated back to Outbound selection. All previous selections cleared.");
  }

  void backToSelectReturnFlights() {
    _updateState(
      _state.copyWith(
        // 1. Cập nhật trạng thái UI
        ui: _state.ui.copyWith(
          isViewingReturnFlights: true, // Chắc chắn hiển thị danh sách chặng về
          errorMessage: null,            // Xóa thông báo lỗi nếu có
        ),

        // 2. Xóa chặng về đã chọn nhưng GIỮ LẠI chặng đi
        data: _state.data.copyWith(
          resetReturn: true, // Chỉ xóa chặng về, giữ lại chặng đi
        ),
      ),
    );

    // 3. Cuộn màn hình lên đầu danh sách chặng về để khách chọn lại
    scrollToTop();

    debugPrint(">>> [Flight] Navigated back to Return selection. Departure flight kept.");
  }

  // ===== 1. LOGIC: Cập nhật Tab hiện tại =====
  void updateTab(FlightTab tab) {
    // Nếu nhấn vào tab hiện tại thì không làm gì
    if (_state.ui.selectedFlightTab == tab) return;

    _updateState(_state.copyWith(
      ui: _state.ui.copyWith(
        selectedFlightTab: tab,
        errorMessage: '', // Xóa lỗi cũ khi chuyển tab
        isLoading: false,  // Đảm bảo không bị kẹt loading
      ),
      // Khi chuyển tab lớn, thường ta nên reset các lựa chọn chuyến bay cũ
      data: _state.data.copyWith(
        selectedOutboundFlight: null,
        selectedReturnFlight: null,
        selectedInternationalFlight: null,
        outboundFlights: [],
        returnFlights: [],
      ),
    ));

    debugPrint(">>> [Flight] Tab updated to: $tab");
  }

  // ===== 2. LOGIC: Reset Search (Về trạng thái ban đầu) =====
  void resetSearch() {
    _updateState(_state.copyWith(
      ui: _state.ui.copyWith(
        isLoading: false,
        isViewingReturnFlights: false, // Quay về màn hình chọn chặng đi
        errorMessage: '',
      ),
      data: _state.data.copyWith(
        // Xóa danh sách kết quả nhưng giữ lại listAirport đã load
        outboundFlights: [],
        returnFlights: [],
        internationalFlights: [],
        selectedOutboundFlight: null,
        selectedReturnFlight: null,
        selectedInternationalFlight: null,
      ),
    ));

    // Cuộn lên đầu trang form tìm kiếm
    scrollToTop();
    debugPrint(">>> [Flight] Search results cleared, back to form.");
  }

  // ===== 3. LOGIC: Xử lý khi chọn Home hoặc Reset toàn bộ =====
  // Hàm này thường được gọi khi nhấn vào trang chủ trên Drawer
  void resetToHome() {
    _updateState(FlightState.initial().copyWith(
      // Giữ lại dữ liệu nền đã load thành công để không phải gọi API lại
      data: FlightDataState.initial().copyWith(
        listAirport: _state.data.listAirport,
        listCheapFlight: _state.data.listCheapFlight,
      ),
      ui: FlightUiState.initial().copyWith(
        isInitialized: _state.ui.isInitialized,
      ),
    ));
    scrollToTop();
  }

  Future<bool> createBooking({
    required List<PassengerRequest> passengers,
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required String contactConfirmEmail,
    String? specialRequest,
    bool hasBill = false,
    String? billCompany,
    String? billMst,
    String? billAddress,
  }) async {
    // 1. Bật trạng thái loading
    _updateState(_state.copyWith(
      ui: _state.ui.copyWith(isLoading: true, errorMessage: null),
    ));

    try {
      final data = _state.data;

      // 2. Logic tìm Index của hạng ghế đã chọn (Server yêu cầu Index dạng String)
      // Tìm trong danh sách inventories của chặng đi
      int goFareIndex = data.selectedOutboundFlight?.inventories?.indexWhere(
            (inv) => inv.fareType == data.selectedOutboundInventory?.fareType,
      ) ?? 0;

      // Tìm trong danh sách inventories của chặng về (nếu có)
      int reFareIndex = data.selectedReturnFlight?.inventories?.indexWhere(
            (inv) => inv.fareType == data.selectedReturnInventory?.fareType,
      ) ?? 0;

      // 3. Khởi tạo đối tượng Request
      final request = FlightBookingRequest(
        // Payload này lấy từ kết quả trả về của API Search trước đó
        payload: data.payload,
        flightGoSelected: data.selectedOutboundFlight?.uniqueId,
        flightGoSelectedFareClassIndex: (goFareIndex != -1 ? goFareIndex : 0).toString(),
        flightReturnSelected: data.selectedReturnFlight?.uniqueId,
        flightReturnSelectedFareClassIndex: (reFareIndex != -1 ? reFareIndex : 0).toString(),

        // Thông tin hành khách truyền từ UI form
        passenger: passengers,

        // Thông tin người liên hệ
        customerName: contactName,
        customerPhone: contactPhone,
        customerEmail: contactEmail,
        confirmCustomerEmail: contactConfirmEmail,
        customerSpecialRequest: specialRequest ?? "",
        customerCountryCode: "VN",

        // Thông tin hóa đơn
        hasExportBill: false,
        billCompany: null,
        billMst: null,
        billAddress: null,
        billReceiver: null,

        // Unique ID cho mỗi lần nhấn nút (tránh trùng lặp)
        requestId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // 4. Gọi Service
      final response = await _bookingService.createFlightBooking(request);

      if (response != null && response.status == 1) {
        // THÀNH CÔNG: Lưu kết quả vào State
        _updateState(_state.copyWith(
          data: _state.data.copyWith(bookingSummary: response),
          ui: _state.ui.copyWith(isLoading: false),
        ));

        debugPrint(">>> [Flight] Booking Success: ${response.message}");
        // Tại UI bạn sẽ thực hiện Navigator.push sang trang FlightBookingSummaryScreen
        return true;
      } else {
        // THẤT BẠI: Hiển thị lỗi từ Server
        _updateState(_state.copyWith(
          ui: _state.ui.copyWith(
              isLoading: false,
              errorMessage: response?.message ?? "Đặt chỗ không thành công, vui lòng thử lại."
          ),
        ));
        return false;
      }
    } catch (e) {
      // LỖI HỆ THỐNG/MẠNG
      debugPrint(">>> [Flight] Booking Logic Error: $e");
      _updateState(_state.copyWith(
        ui: _state.ui.copyWith(isLoading: false, errorMessage: e.toString()),
      ));
      return false;
    }
  }

  void clearBookingSummary() {
    _updateState(_state.copyWith(    data: _state.data.copyWith(
      resetSummary: true, // Đảm bảo hàm copyWith trong State hỗ trợ resetSummary về null
    ),
    ));
    scrollToTop();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
