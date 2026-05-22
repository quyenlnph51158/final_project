import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/navigation/navigation_service.dart';
import 'package:final_project/core/utils/format_date.dart';
import 'package:final_project/features/train/data/models/cheap_journey.dart';
import 'package:final_project/features/train/data/models/list_city.dart';
import 'package:final_project/features/train/data/models/passenger_model.dart';
import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/train_booking_request/create_booking_request.dart';
import 'package:final_project/features/train/data/service/create_booking_service.dart';
import 'package:final_project/features/train/data/service/list_city_service.dart';
import 'package:final_project/features/train/data/service/search_train_service.dart';
import 'package:final_project/features/train/data/service/train_cheap_journey_service.dart';
import 'package:final_project/features/train/data/service/train_destinations_service.dart';
import 'package:final_project/features/train/presentation/screens/train_results_screen.dart';
import 'package:final_project/features/train/presentation/state/train_filter_state.dart';
import 'package:final_project/features/train/presentation/state/train_form_state.dart';
import 'package:final_project/features/train/presentation/state/train_state.dart';
import 'package:final_project/features/train/presentation/state/train_ui_state.dart';
import 'package:flutter/material.dart';
import '../../data/models/destination.dart';
import '../../data/models/train_model.dart';

class TrainController extends ChangeNotifier {
  TrainState _state = TrainState.initial();

  TrainState get state => _state;

  // --- CÁC BIẾN KHÓA ĐỒNG BỘ (BẢO VỆ API) ---
  bool _isInitializing = false;
  bool _isFetchingTrain = false;
  bool _isBooking = false;

  // --- QUẢN LÝ SCROLL & KEYS ---
  final scrollController = ScrollController();
  final GlobalKey departureTrainList = GlobalKey();
  final GlobalKey returnTrainList = GlobalKey();
  final GlobalKey continueButton = GlobalKey();

  // --- KHỞI TẠO SERVICES (SINGLETON STYLE) ---
  final _listCityService = ListCityService();
  final _destinationService = DestinationService();
  final _cheapJourneyService = CheapJourneyService();
  final _searchTrainService = SearchTrainService();
  final _bookingService = CreateBookingService();

  // 1. CÁC HÀM SCROLL (GIỮ NGUYÊN)
  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 100), () {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          alignment: 0.1,
          curve: Curves.easeInOut,
        );
      } else {
        scrollToTop();
      }
    });
  }

  // 2. INIT DATA (THÊM KHÓA CHẶN TRÙNG LẶP)
  Future<void> initData() async {
    // Nếu đã xong hoặc đang chạy thì không cho vào
    if (_state.ui.isInitialized || _isInitializing) return;

    _isInitializing = true;
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoading: true)));

    try {
      debugPrint(">>> [Train] API Init starting...");
      final results = await Future.wait([
        _listCityService.fetchListCity(),
        _destinationService.fetchDestinations(),
        _cheapJourneyService.fetchCheapJourneys(),
      ]);

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            cities: results[0] as List<ListCity>,
            destinations: results[1] as List<Destination>,
            cheapJourneys: results[2] as List<CheapJourney>,
          ),
          ui: _state.ui.copyWith(isLoading: false, isInitialized: true),
        ),
      );
    } catch (e) {
      debugPrint(">>> [Train] API Init Error: $e");
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoading: false, errorMessage: e.toString()),
        ),
      );
    } finally {
      _isInitializing = false; // Mở khóa
    }
  }

  // 3. FETCH TRAIN (THÊM KHÓA CHẶN SPAM TÌM KIẾM)
  Future<void> fetchTrain() async {
    if (_isFetchingTrain) return;
    _isFetchingTrain = true;

    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    try {
      final response = await _searchTrainService.fetchSearchTrains(
        startStationCode: state.form.DepartureCode,
        endStationCode: state.form.DestinationCode,
        startDate: state.form.DepartureDate,
        endDate: state.form.ReturnDate,
        typeStation: state.form.isRoundTrip ? '2' : '1',
        adultCount: state.form.adultCount.toString(),
        childCount: state.form.childCount.toString(),
        infantCount: state.form.infantCount.toString(),
      );

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            payload: response.payloadTrain,
            originalDepartureListTrain: response.DepartureListTrain,
            originalReturnListTrain: response.ReturnListTrain,
            DepartureListTrain: response.DepartureListTrain,
            ReturnListTrain: response.ReturnListTrain,
          ),
          ui: _state.ui.copyWith(isLoading: false, errorMessage: ''),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            isLoading: false,
            errorMessage: "Không thể lấy dữ liệu tàu: $e",
          ),
        ),
      );
    } finally {
      _isFetchingTrain = false;
    }
  }

  // 4. CREATE BOOKING (THÊM KHÓA CHẶN SPAM ĐẶT VÉ)
  Future<void> CreateBooking({
    required List<PassengerModel> passengers,
    List<SpecialRequestModel>? extraService,
    required String CustomerName,
    required String CustomerCountryCode,
    required dynamic CustomerPhonNumber, // Giữ nguyên tên biến cũ của bạn
    required String CustomerEmail,
    String? customerNote,
  }) async {
    if (_isBooking) return;
    _isBooking = true;

    try {
      final indexGo = state.data.SelectedDepartureTrain?.seatClass!.indexWhere(
        (i) => i.title == state.data.SelectedDepartureSeatClass?.title,
      );
      final indexReturn = state.data.SelectedReturnTrain?.seatClass!.indexWhere(
        (i) => i.title == state.data.SelectedReturnSeatClass?.title,
      );

      final request = CreateBookingRequest(
        payload: state.data.payload,
        trainGoSelected: state.data.SelectedDepartureTrain?.unique,
        trainGoSelectedFareClassIndex: indexGo,
        trainReturnSelected: state.data.SelectedReturnTrain?.unique,
        trainReturnSelectedFareClassIndex: indexReturn,
        passenger: passengers,
        customerName: CustomerName,
        customerPhone: CustomerPhonNumber,
        customerEmail: CustomerEmail,
        customerCountryCode: CustomerCountryCode,
        extra: extraService,
        customer_note: customerNote
      );

      final response = await _bookingService.createTrainBooking(request);
      if (response != null) {
        _updateState(
          _state.copyWith(
            data: _state.data.copyWith(summaryTrainResponseData: response.data),
          ),
        );
      }
    } catch (e) {
      debugPrint(">>> [Booking Error]: $e");
    } finally {
      _isBooking = false;
    }
  }

  // --- CÁC HÀM CẬP NHẬT TRẠNG THÁI (GIỮ NGUYÊN 100%) ---

  void _updateState(TrainState newState) {
    _state = newState;
    notifyListeners();
  }

  void updateTripType(bool isRoundTrip) {
    _updateState(
      _state.copyWith(form: _state.form.copyWith(isRoundTrip: isRoundTrip)),
    );
  }

  void setDate({required bool returnDate, required String dateTime}) {
    _updateState(
      returnDate
          ? _state.copyWith(form: _state.form.copyWith(ReturnDate: dateTime))
          : _state.copyWith(
              form: _state.form.copyWith(DepartureDate: dateTime),
            ),
    );
  }

  void selectCity({required bool isDeparture, required ListCity city}) {
    if (isDeparture) {
      _updateState(
        _state.copyWith(
          form: _state.form.copyWith(
            Departure: city.name,
            DepartureCode: city.code,
          ),
        ),
      );
    } else {
      _updateState(
        _state.copyWith(
          form: _state.form.copyWith(
            Destination: city.name,
            DestinationCode: city.code,
          ),
        ),
      );
    }
  }

  List<ListCity> FilteredCities(String query) {
    String q = query.toLowerCase().trim();
    if (q.isEmpty) return _state.data.cities;
    return _state.data.cities.where((city) {
      final String name = city.name!.toLowerCase().trim();
      final String code = city.code!.toLowerCase().trim();
      return name.contains(q) || code.contains(q);
    }).toList();
  }

  void updatePassengerData({
    required int adults,
    required int childs,
    required int infants,
  }) {
    _updateState(
      _state.copyWith(
        form: _state.form.copyWith(
          adultCount: adults,
          childCount: childs,
          infantCount: infants,
        ),
      ),
    );
  }

  void navigateToTrainResults(AppLocalizations l10n) {
    if (state.form.DepartureCode.isEmpty ||
        state.form.DestinationCode.isEmpty) {
      _updateState(
        state.copyWith(
          ui: _state.ui.copyWith(
            errorMessage: l10n.error_flightSearchMissingInput,
          ),
        ),
      );
      return;
    }
    _updateState(
      state.copyWith(
        ui: _state.ui.copyWith(isSearching: true, errorMessage: null),
      ),
    );
    try {
      NavigationService.push(
        MaterialPageRoute(builder: (_) => TrainResultScreen()),
      );
    } catch (e) {
      _updateState(
        state.copyWith(
          ui: _state.ui.copyWith(
            errorMessage: '${l10n.error_flightSearchConnectionFailed} $e',
          ),
        ),
      );
    } finally {
      _updateState(state.copyWith(ui: _state.ui.copyWith(isSearching: false)));
    }
  }

  void backToSearch() {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          originalDepartureListTrain: [],
          originalReturnListTrain: [],
          DepartureListTrain: [],
          ReturnListTrain: [],
          SelectedDepartureTrain: null,
          SelectedReturnTrain: null,
          SelectedDepartureSeatClass: null,
          SelectedReturnSeatClass: null,
        ),
        form: _state.form.copyWith(
          Departure: '',
          Destination: '',
          DepartureCode: '',
          DestinationCode: '',
          DepartureDate: FormatDate.formatDateDDMMYYYY(DateTime.now()),
          ReturnDate: '',
          isRoundTrip: true,
        ),
        ui: _state.ui.copyWith(
          isSearching: false,
          isViewingReturnTrain: false,
          isLoading: false,
          errorMessage: null,
          isSelectedDepartureTrain: false,
          isSelectedReturnTrain: false,
        ),
      ),
    );
  }

  void selectDepartureTrain(TrainModel train, SeatClass seat) {
    state.ui.isViewingReturnTrain
        ? _updateState(
            _state.copyWith(
              data: _state.data.copyWith(
                SelectedReturnSeatClass: seat,
                SelectedReturnTrain: train,
              ),
              ui: _state.ui.copyWith(isSelectedReturnTrain: true),
            ),
          )
        : _updateState(
            _state.copyWith(
              data: _state.data.copyWith(
                SelectedDepartureTrain: train,
                SelectedDepartureSeatClass: seat,
              ),
              ui: _state.ui.copyWith(
                isViewingReturnTrain: true,
                isSelectedDepartureTrain: true,
              ),
            ),
          );
  }

  void updateSelectedTrain(SeatClass seat) {
    state.ui.isViewingReturnTrain
        ? _updateState(
            _state.copyWith(
              data: _state.data.copyWith(SelectedReturnSeatClass: seat),
            ),
          )
        : _updateState(
            _state.copyWith(
              data: _state.data.copyWith(SelectedDepartureSeatClass: seat),
            ),
          );
  }

  void toggleTrainFilter({String? filterStart, String? filterEnd}) {
    final List<String> filterTimeStartctr = List.from(
      state.filter.filterTimeStart,
    );
    final List<String> filterTimeEndctr = List.from(state.filter.filterTimeEnd);
    if (filterStart != null) {
      state.filter.filterTimeStart.contains(filterStart)
          ? filterTimeStartctr.remove(filterStart)
          : filterTimeStartctr.add(filterStart);
    }
    if (filterEnd != null) {
      state.filter.filterTimeEnd.contains(filterEnd)
          ? filterTimeEndctr.remove(filterEnd)
          : filterTimeEndctr.add(filterEnd);
    }
    _updateState(
      _state.copyWith(
        filter: _state.filter.copyWith(
          filterTimeStart: filterTimeStartctr,
          filterTimeEnd: filterTimeEndctr,
        ),
      ),
    );
  }

  bool isFilterTimeRange(String timeStr, List<String> selectedTimeRange) {
    if (selectedTimeRange.isEmpty) return true;
    final hour = int.parse(timeStr.split(':').first);
    for (var i in selectedTimeRange) {
      if (i == 'Sớm' && hour >= 0 && hour < 6) return true;
      if (i == 'Sáng' && hour >= 6 && hour < 12) return true;
      if (i == 'Trưa' && hour >= 12 && hour < 18) return true;
      if (i == 'Tối' && hour >= 18 && hour < 24) return true;
    }
    return false;
  }

  void applyTrainFilter() {
    final departureTrains = _state.data.originalDepartureListTrain.where((
      train,
    ) {
      bool matchStart = isFilterTimeRange(
        train.timeStart ?? '',
        state.filter.filterTimeStart,
      );
      bool matchEnd = isFilterTimeRange(
        train.timeEnd ?? '',
        state.filter.filterTimeEnd,
      );
      return matchStart && matchEnd;
    }).toList();
    final returnTrains = _state.data.originalReturnListTrain.where((train) {
      bool matchStart = isFilterTimeRange(
        train.timeStart ?? '',
        state.filter.filterTimeStart,
      );
      bool matchEnd = isFilterTimeRange(
        train.timeEnd ?? '',
        state.filter.filterTimeEnd,
      );
      return matchStart && matchEnd;
    }).toList();
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          DepartureListTrain: departureTrains,
          ReturnListTrain: returnTrains,
        ),
      ),
    );
    scrollToTop();
  }

  void resetToInitial() {
    // Reset cả các biến khóa
    _isInitializing = false;
    _isFetchingTrain = false;
    _isBooking = false;
    _updateState(
      _state.copyWith(
        ui: TrainUiState.initial().copyWith(isInitialized: true),
        form: TrainFormState.initial(),
        filter: TrainFilterState.initial(),
        data: _state.data.copyWith(
          originalDepartureListTrain: [],
          originalReturnListTrain: [],
          DepartureListTrain: [],
          ReturnListTrain: [],
          SelectedDepartureTrain: null,
          SelectedReturnTrain: null,
          SelectedDepartureSeatClass: null,
          SelectedReturnSeatClass: null,
          devices: null,
        ),
      ),
    );
  }

  void backToSelectDepartureTrain() {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          SelectedDepartureTrain: null,
          SelectedDepartureSeatClass: null,
          SelectedReturnTrain: null,
          SelectedReturnSeatClass: null,
          DepartureListTrain: state.data.originalDepartureListTrain,
          ReturnListTrain: state.data.originalReturnListTrain,
        ),
        ui: _state.ui.copyWith(
          isSelectedDepartureTrain: false,
          isSelectedReturnTrain: false,
          isViewingReturnTrain: false,
        ),
        filter: _state.filter.copyWith(filterTimeStart: [], filterTimeEnd: []),
      ),
    );
  }

  void selectPromotionCard(String departure, String destination) {
    _updateState(
      _state.copyWith(
        form: _state.form.copyWith(
          Departure: departure,
          Destination: destination,
        ),
      ),
    );
  }

  void backToSelectReturnTrain() {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          SelectedReturnSeatClass: null,
          SelectedReturnTrain: null,
        ),
        ui: _state.ui.copyWith(isSelectedReturnTrain: false),
      ),
    );
  }

  void validateForm(AppLocalizations l10n) {
    final f = state.form;
    String error = '';
    final DateTime? depDate = FormatDate.parseStringToDate(f.DepartureDate);
    final DateTime? retDate = f.isRoundTrip
        ? FormatDate.parseStringToDate(f.ReturnDate)
        : null;

    if (f.DepartureCode.isEmpty) {
      error = l10n.errorDepartureEmpty;
    } else if (f.DestinationCode.isEmpty) {
      error = l10n.errorDestinationEmpty;
    } else if (f.DepartureCode == f.DestinationCode) {
      error = l10n.errorSameLocation;
    } else if (f.isRoundTrip && f.ReturnDate.isEmpty) {
      error = l10n.errorReturnDateEmpty;
    } else if (f.isRoundTrip &&
        retDate != null &&
        depDate != null &&
        retDate.isBefore(depDate)) {
      error = l10n.errorReturnBeforeDeparture;
    } else if (f.isRoundTrip &&
        retDate != null &&
        depDate != null &&
        retDate == depDate) {
      error = l10n.errorSameDate;
    }
    _updateState(_state.copyWith(ui: _state.ui.copyWith(errorMessage: error)));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
