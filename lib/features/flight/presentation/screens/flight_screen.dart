import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../tour/presentation/widgets/header/header_back_ground.dart';
import '../controller/flight_controller.dart';
import '../form/search_form.dart';
import '../widgets/destination_item.dart';
import '../widgets/extra_section.dart';
import '../widgets/featured_list_cheap_flight_section.dart';
import '../widgets/flight_feature_card.dart';
import 'package:provider/provider.dart';

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
  String DepartureCode = '';

  String ArrivalCode = '';

  DateTime? departureDate;
  DateTime? returnDate;


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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<FlightController>();
      controller.resetToInitial();
      context.read<FlightController>().initData();
    });
  }

  // ----------------------- 5.6. Widget Build Chính (build) -----------------------

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FlightController>();
    final state= context.watch<FlightController>().state;
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    const double extraContentHeight = 200;
    final double formHeight =
    state.selectedFlightTab == FlightTab.flight ?320 :120;

    final double containerHeight =
        headerHeight + formHeight + extraContentHeight;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      endDrawer: AppDrawer(
        onTabSelected:(_) =>
            controller.updateTab(FlightTab.flight) ,
        onHomeSelected: controller.resetSearch,
        onTabFlightSelected: controller.updateTab,
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
            children: [
              SizedBox(
                height: containerHeight,
                child: Stack(
                  children: [
                    // 1. Background Header
                    HeaderBackground(height: headerHeight, image: 'https://img2.thuthuat123.com/uploads/2019/11/19/anh-background-bau-troi-cuc-chat-cuc-dep_122621398.jpg',),
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
                      child: SearchForm(),
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
                      return DestinationItem(destination: dest, itemWidth: baseItemWidth);
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 32.0),

              // --- Chuyến bay giá rẻ ---
              FeaturedListCheapFlightSection(),
              const SizedBox(height: 32.0),

              // --- Dịch vụ bổ sung ---
              ExtraSection(ExtraService: ExtraService,),
              const SizedBox(height: 20.0),

              // --- Footer ---
              const AppFooter(),
            ]
        ),
      ),
    );
  }
}