// =============================================================================
//                             1. IMPORTS
// =============================================================================
import 'package:final_project/features/flight/presentation/inputs/code_seat_input.dart';
import 'package:final_project/features/tour/presentation/screens/booking/forms/flight_search_form.dart';
import 'package:final_project/features/tour/presentation/screens/booking/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/flight/data/models/list_cheap_flight.dart';
import 'package:final_project/features/flight/data/service/listairport_service.dart';
import 'package:final_project/features/flight/data/service/listcheapflight_service.dart';
import 'package:final_project/features/flight/data/models/list_airport.dart';
import 'package:final_project/features/flight/presentation/screens/flight_results_screen.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../widgets/flight_feature_card.dart';
import '../widgets/service_card.dart';

// =============================================================================
//                      2. ENUMS & HẰNG SỐ CỦA MÀN HÌNH
// =============================================================================
// =============================================================================
//                     3. MODELS/STRUCTS (Stateless Widgets)
// =============================================================================
/// ---------------------- 3.1. FlightDealCard (Card Ưu đãi) ----------------------
class FlightDealCard extends StatelessWidget {
  final String imageUrl;
  final String route;
  final String date;
  final String price;
  final String tripType;

  const FlightDealCard({
    super.key,
    required this.imageUrl,
    required this.route,
    required this.date,
    required this.price,
    required this.tripType,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      clipBehavior: Clip.antiAlias, // Cắt ảnh theo border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hình ảnh
          Image.network(
            imageUrl,
            height: 180, // Chiều cao cố định
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey.shade200,
                child: Center(
                    child: Text(l10n.error_image_load, style: TextStyle(color: Colors.grey))),
              );
            },
          ),

          // 2. Nội dung text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tuyến bay: Từ Hà Nội Đến Đà Nẵng
                Text(
                  route,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Ngày khởi hành
                Row(
                  children: [
                    const Icon(
                      Icons.schedule, // Hoặc Icons.access_time
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Giá và Nút Chi tiết
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.flight_label_only_from,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700, // Màu đỏ nổi bật cho giá
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tripType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    // Nút "Chi tiết"
                    OutlinedButton(
                      onPressed: () {
                        // Xử lý khi nhấn Chi tiết
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        l10n.general_detailButton,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//                           4. MÀN HÌNH CHÍNH (Stateful Widget)
// =============================================================================

/// ----------------------- 4.1. FlightScreen -----------------------
class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});
  @override
  State<FlightScreen> createState() => _FlightScreen();
}

// =============================================================================
//                             5. STATE CỦA MÀN HÌNH
// =============================================================================

class _FlightScreen extends State<FlightScreen> {
  // ----------------------- 5.1. Khai báo Controller & Service -----------------------
  final ScrollController _scrollController = ScrollController();
  final ListcheapflightService _listCheapFlightService= ListcheapflightService();
  final ListAirportService _listAirportService= ListAirportService();
  bool _isSearching = false;

  // ----------------------- 5.2. Biến State Chính -----------------------
  TravelTab _selectedTab= TravelTab.flight;
  FlightTab _selectedFlightTab=FlightTab.flight;
  bool _isRoundTrip = true;
  bool _isLoading = true;
  List<ListCheapFlight> _listCheapFlight=[];
  List<ListAirport> _listAirport=[];
  String? _errorMessage;

  // ----------------------- 5.3. Biến Form State -----------------------
  final TextEditingController _codeSeatController= TextEditingController(text: 'Mã đặt chỗ');
  final TextEditingController _emailController=TextEditingController(text: 'Email');
  late final TextEditingController _destinationController;
  String DepartureCode = '';
  late final TextEditingController _departureController;
  String ArrivalCode = '';

  String _selectedDate =
      '${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}';
  late String _returnDate;
  DateTime? departureDate;
  DateTime? returnDate;

  int _adultCount = 1;
  int _childCount = 0;
  int _infantCount = 0;
  late String _selectedClass;
  bool _isSearchingFlight = false;
  String? _flightSearchError;
  bool _isInitialized=false;

  // ✈️ Dữ liệu tĩnh (static const) cho các điểm đến
  static const List<Map<String, dynamic>> destinations = [
    {
      'name': 'Bangkok',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/bk12344.jpg?itok=XlV-k-kJ',
      'type': 'normal',
    },
    {
      'name': 'Siem Reap',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/Hinh-anh-Siem-Reap-nhin-tu-tren-cao-dep.jpg?itok=Iq6cgnlI',
      'type': 'normal',
    },
    {
      'name': 'Sydney',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/nha-hat-opera-sydney-2.jpeg?itok=UE5eLKeE',
      'type': 'special',
    },
    {
      'name': 'Singapore',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/sing1.jpg?itok=2fPyDrgT',
      'type': 'normal',
    },
    {
      'name': 'Melbourne',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/Mel.jpg?itok=zn7XNLgb',
      'type': 'normal',
    },
    {
      'name': 'London',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/london_5.jpg?itok=UVzbEQH2',
      'type': 'special',
    },
    {
      'name': 'Paris',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/pariii.jpg?itok=LzMY9Z2O',
      'type': 'normal',
    },
    {
      'name': 'Frankfurt',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/frank.jpg?itok=As2mjFyW',
      'type': 'normal',
    },
    {
      'name': 'San Francisco',
      'imageUrl': 'https://webservice.annguyen.vn/sites/default/files/styles/width_650/public/destination/10-dieu-thu-vi-khi-du-lich-san-francisco-1.jpg?itok=5js4ORbk',
      'type': 'special',
    },
  ];
  final List<Map<String, dynamic>> ExtraService =[
    {
      'title': 'Hành lý trả trước',
      'subtitle': 'Tiết kiệm thời gian và tiền bạc - Vui lòng liên hệ với chúng tôi để mua hành lý quá cước trả trước',
      'imageUrl': 'https://www.wonderingvietnam.com/assets/img/flight/service_1.png',
    },
    {
      'title': 'Chọn món ăn yêu thích',
      'subtitle': 'Thưởng thức bữa ăn hoàn hảo - Chúng tôi sẽ giúp bạn chọn món ăn yêu cầu với giá hợp lý',
      'imageUrl': 'https://www.wonderingvietnam.com/assets/img/flight/service_2.png',
    },
    {
      'title':'Làm thủ tục trực tuyến',
      'subtitle':'Thủ tục check-in trở nên thuận tiện và dễ dàng hơn bao giờ hết với dịch vụ check-in trực tuyến của chúng tôi',
      'imageUrl': 'https://www.wonderingvietnam.com/assets/img/flight/service_3.png',
    },
    {
      'title': 'Đặt chỗ ngồi',
      'subtitle':'Tận hưởng không gian thoải mái - Chúng tôi cung cấp dịch vụ chọn chỗ ngồi hạng cao cho hành khách',
      'imageUrl':'https://www.wonderingvietnam.com/assets/img/flight/service_4.png',
    }
  ];

  // ----------------------- 5.4. Vòng đời -----------------------
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if (!_isInitialized) { // CHỈ CHẠY LOGIC NÀY LẦN ĐẦU TIÊN
      final l10n = AppLocalizations.of(context)!;
      _fetchListCheapAirport();
      _fetchListAirport();
      _destinationController = TextEditingController(text: l10n.form_defaultDestination);
      _departureController = TextEditingController(text: l10n.form_consultation_departure_point);
      _returnDate= l10n.form_defaultReturnDate;
      _selectedClass =l10n.form_defaultClass;
      _isInitialized = true; // Đánh dấu đã khởi tạo xong
    }
  }
  // (Không cần dispose vì không có logic đặc biệt)

  // ----------------------- 5.5. Logic Xử lý & API Calls -----------------------

  /// Xử lý cập nhật code sân bay khi chọn từ Ưu đãi
  void _handleDepartureCodeSelected(String departureCodee,String ArrivalCodee, String destinationController, String departureController) {
    setState(() {
      DepartureCode = departureCodee;
      ArrivalCode= ArrivalCodee;
      _destinationController.text=destinationController;
      _departureController.text=departureController;
      _scrollToTop();
    });
  }

  /// Cuộn lên đầu trang
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0, // Vị trí 0.0 là đầu trang
        duration: const Duration(milliseconds: 500), // Thời gian cuộn
        curve: Curves.easeInOut, // Hiệu ứng cuộn mượt mà
      );
    }
  }

  /// Parse chuỗi ngày (dd-MM-yyyy) thành DateTime
  DateTime? _parseDateDDMMYYYY(String dateString) {
    if (dateString == 'Chưa chọn') {
      return null;
    }
    try {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Tải danh sách Sân bay
  Future<void> _fetchListAirport() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final listAirport = await _listAirportService.fetchListAirport();
      setState(() {
        _listAirport = listAirport;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.error_airportDataLoadingFailed} $e';
        _isLoading = false;
      });
    }
  }

  /// Tải danh sách Chuyến bay giá rẻ
  Future<void> _fetchListCheapAirport() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Xóa lỗi cũ
    });
    try {
      final listCheapFlight = await _listCheapFlightService.fetchlistcheapflight();
      setState(() {
        _listCheapFlight = listCheapFlight;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.error_flightDataLoadingFailed} $e';
        _isLoading = false;
      });
    }
  }

  /// Xử lý logic tìm kiếm chuyến bay
  void _searchFlight() async {
    final l10n = AppLocalizations.of(context)!;
    // 1. Kiểm tra đầu vào (Chỉ kiểm tra cho tab Máy bay)
    if(_selectedFlightTab == FlightTab.flight){
      DateTime? departureDate = _parseDateDDMMYYYY(_selectedDate);
      DateTime? returnDate = _parseDateDDMMYYYY(_returnDate);

      // Kiểm tra các trường bắt buộc
      if (DepartureCode.isEmpty || ArrivalCode.isEmpty || departureDate == null || (_isRoundTrip && returnDate == null)) {
        setState(() {
          _flightSearchError = '${l10n.flight_error_fill_info}${_isRoundTrip ? ' & ${l10n.flight_returnDate}' : ''}.';
        });
        return;
      }
      // Kiểm tra ngày về sau ngày đi
      if (_isRoundTrip && departureDate != null && returnDate != null && departureDate.isAfter(returnDate)) {
        setState(() {
          _flightSearchError = l10n.error_flight_date_invalid;
        });
        return;
      }
    } else {
      // Logic kiểm tra cho tab Mã chỗ ngồi
      if(_codeSeatController.text.isEmpty || _emailController.text.isEmpty){
        setState(() {
          _flightSearchError = l10n.flight_error_empty_seat_code;
        });
        return;
      }
      // Có thể thêm logic gọi API tìm kiếm mã đặt chỗ ở đây
      setState(() {
        _flightSearchError = l10n.error_flight_seat_not_implemented;
      });
      return;
    }


    // Đặt trạng thái bắt đầu tìm kiếm
    setState(() {
      _isSearchingFlight = true;
      _flightSearchError = null; // Xóa lỗi cũ
    });
    try {
      if(_selectedFlightTab == FlightTab.flight){
        // Điều hướng đến màn hình kết quả chuyến bay
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FlightResultsScreen(
              departureCode: DepartureCode,
              destinationCode: ArrivalCode,
              departureDate: _selectedDate,
              returnDate: _returnDate,
              adults: _adultCount,
              children: _childCount,
              infant: _infantCount,
              isRoundTrip: _isRoundTrip,
            ),
          ),
        );
      }
      // NẾU LÀ MÃ CHỖ NGỒI, THÌ KHÔNG LÀM GÌ, CHỈ HIỂN THỊ LỖI PHÍA TRÊN
    } catch (e) {
      setState(() {
        _flightSearchError = '${l10n.error_flightSearchConnectionFailed} $e';
      });
    } finally {
      // 5. Kết thúc tìm kiếm
      setState(() {
        _isSearchingFlight = false;
      });
    }
  }


  /// Cuộn đến vị trí Form tìm kiếm
  void _scrollToForm() {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    final double targetScrollPosition = headerHeight - 10;

    _scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Xử lý chọn Tab trong AppDrawer (và cuộn đến Form)
  void _handleFlightTabSelected(FlightTab tab){
    setState((){
      _selectedFlightTab=tab;
    });
    _scrollToForm();
  }
  void _handleDrawerTabSelected(TravelTab tab) {
    setState((){
      _selectedTab = tab;
    });
    _scrollToForm();
  }

  /// Xử lý chọn Home trong AppDrawer (và cuộn lên đầu)
  void _handleDrawerHomeSelected() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }


  // ----------------------- 5.6. Widget Build Chính (build) -----------------------

  @override
  Widget build(BuildContext context) {
    // Tính toán chiều cao linh hoạt cho Stack
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    const double extraContentHeight = 200; // Chiều cao ước tính cho phần ảnh nổi
    // Chiều cao form: Máy bay: ~320 | Mã chỗ ngồi: ~120
    final double formHeight =
    _selectedFlightTab == FlightTab.flight ?320 :120;
    // Phần ảnh nổi không hiển thị khi đang tìm kiếm (chưa có logic _isSearching)
    // final double featuredDestinationsHeight =
    // _isSearching ? 0 : extraContentHeight;

    final double containerHeight =
        headerHeight + formHeight + extraContentHeight;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      endDrawer: AppDrawer(
        onTabSelected: _handleDrawerTabSelected,
        onHomeSelected: _handleDrawerHomeSelected,
        onTabFlightSelected: _handleFlightTabSelected,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
            children: [
              SizedBox(
                height: containerHeight,
                child: Stack(
                  children: [
                    // 1. Background Header
                    _buildHeaderBackground(headerHeight),
                    // 2. AppBar & Tiêu đề
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomAppBar(),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 20.0, right: 20.0),
                              child: Text(
                                l10n.flight_screen_header_title,
                                style: TextStyle(
                                    color: kHeaderTextColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 3. Form Tìm kiếm (Nổi)
                    Positioned(
                      top: headerHeight - 15,
                      left: 16,
                      right: 16,
                      child: _buildSearchForm(context),
                    ),
                  ],
                ),
              ),
              // --- Nội dung bên dưới Form ---
              const SizedBox(height: 20),
              // --- Tiêu đề & Tính năng ---
              Text(
                l10n.flight_screen_service_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // --- Card Tính năng ---
              FlightFeatureCard(
                icon: Icons.luggage_outlined,
                title: l10n.flight_feature_luggage_title,
                subtitle: l10n.flight_feature_luggage_sub,
              ),
              const SizedBox(height: 16),
              FlightFeatureCard(
                icon: Icons.flight_takeoff,
                title: l10n.flight_feature_online_checkin_title,
                subtitle: l10n.flight_feature_online_checkin_sub,
              ),
              const SizedBox(height: 16),
              FlightFeatureCard(
                icon: Icons.flight_rounded,
                title: l10n.flight_feature_checkin_available_title,
                subtitle: l10n.flight_feature_checkin_available_sub,
              ),
              const SizedBox(height: 60),

              // --- Điểm đến quốc tế hàng đầu ---
              Text(l10n.flight_screen_top_destinations,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Phần ảnh dạng Masonry/Wrap
              LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  final double baseItemWidth = (screenWidth - 32) / 2.5;

                  return Wrap(
                    spacing: 8.0, // Khoảng cách ngang
                    runSpacing: 8.0, // Khoảng cách dọc
                    children: destinations.map((dest) {
                      return _buildDestinationItem(context, dest, baseItemWidth);
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 32.0),

              // --- Chuyến bay giá rẻ ---
              _buildFeaturedListCheapFlightSection(),
              const SizedBox(height: 32.0),

              // --- Dịch vụ bổ sung ---
              _buildExtraSection(),
              const SizedBox(height: 20.0),

              // --- Footer ---
              const AppFooter(),
            ]
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------------
  //                            5.7. WIDGET PHỤ
  // -----------------------------------------------------------------------------

  /// ----------------------- Header Background -----------------------
  Widget _buildHeaderBackground(double height) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        image: DecorationImage(
          image: NetworkImage('https://img2.thuthuat123.com/uploads/2019/11/19/anh-background-bau-troi-cuc-chat-cuc-dep_122621398.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  /// ----------------------- Form Wrapper -----------------------
  Widget _buildSearchForm(BuildContext context) {
    Widget currentForm;
    if(_selectedFlightTab==FlightTab.flight){
      currentForm=FlightSearchForm();
    }
    else{
      currentForm=_buildSeatForm(context);
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kFormBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabs(),
            const SizedBox(height: 16),
            currentForm,
          ]
      ),
    );
  }

  /// ----------------------- Form Mã chỗ ngồi -----------------------
  Widget _buildSeatForm(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 20.0),
        CodeSeatInput(label: l10n.flight_enterYourSeatCode , hint: l10n.flight_seatCode, controller: _codeSeatController),
        const SizedBox(height: 20.0),
        CodeSeatInput(label: l10n.flight_enterYourEmail, hint: l10n.footer_emailTitle, controller: _emailController),
        const SizedBox(height: 32.0),
        SearchButton(text: l10n.form_searchFlightButton,),
      ],
    );
  }

  /// ----------------------- Section Ưu đãi Chuyến bay Giá rẻ -----------------------
  Widget _buildFeaturedListCheapFlightSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.flight_viewLatestDeals,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),
          if (_listCheapFlight.isEmpty && !_isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(l10n.flight_noFlightsFound,
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            )
          else if(_isLoading)
            const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          else
            ..._listCheapFlight.map((flight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildListCheapFlightCardItem(flight, _handleDepartureCodeSelected ),
              );
            }).toList(),
        ],
      ),
    );
  }

  /// ----------------------- Card Ưu đãi Chuyến bay Giá rẻ -----------------------
  Widget _buildListCheapFlightCardItem(ListCheapFlight flight,
      void Function(String DepartureCode, String ArrivalCode, String destinationController, String departureController ) onDetailsPressed ) {
    final l10n = AppLocalizations.of(context)!;
    final originAirportCode = flight.originAirportObject.value;
    final originCityName = flight.originAirportObject.label;
    final destinationAirportCode = flight.destinationAirportObject.value;
    final destinationAirportCityname = flight.destinationAirportObject.label;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              flight.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Icon(Icons.error, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.flight_from+ originCityName+l10n.flight_to+ destinationAirportCityname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      flight.type == 'OW' ? l10n.form_tripOneWay : flight.type == 'RT' ? l10n.form_tripRoundTrip : flight.type,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(l10n.flight_label_only_from,
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      flight.price.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Chuyển sang form tìm kiếm chuyến bay với thông tin đã điền
                              _handleDepartureCodeSelected(
                                  originAirportCode,
                                  destinationAirportCode,
                                  destinationAirportCityname,
                                  originCityName
                              );
                              // Đảm bảo tab là Flight
                              if(_selectedFlightTab != FlightTab.flight){
                                setState(() {
                                  _selectedFlightTab = FlightTab.flight;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(l10n.general_detailButton,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------- Section Dịch vụ Bổ sung -----------------------
  Widget _buildExtraSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.flight_extraServices,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...ExtraService.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ServiceCard(service: service),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// ----------------------- Item Điểm đến -----------------------
  Widget _buildDestinationItem(
      BuildContext context, Map<String, dynamic> destination, double itemWidth) {

    // Logic xác định kích thước cho bố cục Masonry
    double widthFactor = 0;
    double heightFactor = 0;
    switch (destination['type']) {
      case 'special':
        widthFactor = 2.1;
        heightFactor = 1.2;
        break;
      case 'normal':
        widthFactor=1.0;
        heightFactor=1.5;
      default:
        widthFactor = 1.0;
        heightFactor = 1.0;
        break;
    }

    double finalWidth = itemWidth * widthFactor;
    double finalHeight = itemWidth * heightFactor;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      // **Không sử dụng InkWell/GestureDetector**
      child: Container(
        width: finalWidth,
        height: finalHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Hình ảnh
            Image.network(
              destination['imageUrl'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, color: Colors.red));
              },
            ),

            // 2. Lớp phủ (Overlay)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),

            // 3. Tên điểm đến (Định vị ở dưới cùng)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 50,
                    height: 3,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------------
  //                            5.8. WIDGET FORM COMPONENTS
  // -----------------------------------------------------------------------------

  /// ----------------------- Tabs Máy bay / Mã chỗ ngồi -----------------------
  Widget _buildTabs() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: FlightTab.values.map((tab) {
        final isSelected = _selectedFlightTab == tab;
        String text;
        IconData icon;
        switch (tab) {
          case FlightTab.flight:
            text = l10n.menu_tabFlight;
            icon = Icons.flight_outlined;
            break;
          case FlightTab.codeseat:
            text = l10n.flight_seatCode;
            icon = Icons.tag_outlined;
            break;
        }

        return Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedFlightTab = tab;
                // Reset form khi chuyển tab
                _returnDate = l10n.form_defaultReturnDate;
                _isRoundTrip = true;
                _flightSearchError = null;
                // Cập nhật lại text field để khớp với state khởi tạo của chúng
                if (_selectedFlightTab == FlightTab.flight) {
                  _destinationController.text = l10n.form_labelDestination;
                  _departureController.text = l10n.form_labelDeparturePlace;
                  DepartureCode = '';
                  ArrivalCode = '';
                } else if (_selectedFlightTab == FlightTab.codeseat) {
                  _codeSeatController.text = l10n.flight_bookingCode;
                  _emailController.text = l10n.footer_emailTitle;
                }

              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? kPrimaryColor : Colors.transparent,
                    width: 3.0,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(icon, color: isSelected ? kPrimaryColor : Colors.grey),
                  Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? kPrimaryColor : Colors.grey,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  /// ----------------------- Nút Tìm kiếm Chính -----------------------
  Widget _buildSearchButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // 1. Nút Tìm kiếm
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isSearchingFlight ? null : _searchFlight, // Vô hiệu hóa khi đang tải
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
            child: _isSearchingFlight
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
                : Text(
              l10n.form_searchFlightButton,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // 2. Hiển thị thông báo lỗi (nếu có)
        if (_flightSearchError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _flightSearchError!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}