import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import '../../../../core/utils/responsive_layout.dart'; // Đảm bảo import extension mới
import '../../../flight/presentation/controller/flight_controller.dart';
import '../../../train/presentation/controller/train_controller.dart';
import '../booking/forms/search_form_container.dart';
import '../controller/travel_booking_controller.dart';
import '../sections/home_screen/about_us_section.dart';
import '../sections/home_screen/featured_tour_section.dart';
import '../sections/home_screen/featured_categories_section.dart';
import '../sections/home_screen/header_section.dart';
import '../sections/home_screen/promotion_section.dart';
import '../widgets/header/header_back_ground.dart';

class TravelBookingScreen extends StatefulWidget {
  const TravelBookingScreen({super.key});

  @override
  State<TravelBookingScreen> createState() => _TravelBookingScreenState();
}

class _TravelBookingScreenState extends State<TravelBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();

      controller.initData(
        l10n.form_defaultDeparture,
        l10n.form_defaultDestination,
      );
      controller.resetToHome(l10n.form_defaultDeparture);

      context.read<FlightController>().initData();
      context.read<TrainController>().initData();
      context.read<FlightController>().resetToInitial();
      context.read<TrainController>().resetToInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (TravelBookingController c) => c.state.ui.selectedTab,
    );
    final isSearching = context.select(
      (TravelBookingController c) => c.state.ui.isSearching,
    );
    final scrollController = context
        .read<TravelBookingController>()
        .scrollController;

    // 1. TÍNH TOÁN CHIỀU CAO THEO PIXEL THIẾT KẾ (Base 812px)

    // Chiều cao nền xanh Header (Thiết kế khoảng 280px)
    final double baseHeaderHeight = context.rh(280).clamp(240.0, 320.0);

    // Chiều cao ước tính của Form (Tour khoảng 440px, Flight/Train khoảng 550px)
    double searchFormHeightEstimate;
    if (selectedTab == TravelTab.tour) {
      searchFormHeightEstimate = context.rh(440);
    } else {
      searchFormHeightEstimate = context.rh(560);
    }

    // Khoảng cách Form "ăn gian" đè lên nền (Thiết kế khoảng 40-50px)
    final double overlapOffset = context.rh(40);

    // Tổng chiều cao khu vực Header để đẩy nội dung bên dưới xuống đúng chỗ
    final double totalHeaderStackHeight =
        (baseHeaderHeight - overlapOffset) + searchFormHeightEstimate;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: kFormBackgroundColor,
        endDrawer: const AppDrawer(),
        body: CustomScrollView(
          controller: scrollController,
          // BouncingScrollPhysics giúp trải nghiệm cuộn trên máy thật mượt mà hơn
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ================= RESPONSIVE HEADER =================
            SliverToBoxAdapter(
              child: SizedBox(
                height: totalHeaderStackHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Lớp nền xanh phía sau
                    HeaderBackground(height: baseHeaderHeight),

                    // Nội dung text giới thiệu (Slogan)
                    const HeaderSection(),

                    // Form tìm kiếm
                    Positioned(
                      top: baseHeaderHeight - overlapOffset,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.padding,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: SearchFormContainer(
                              selectedTab: selectedTab,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= CONTENT SECTIONS =================
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.padding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (!isSearching) ...[
                    SizedBox(height: context.rh(32)),
                    const FeaturedDestinationSection(),
                  ],

                  SizedBox(height: context.rh(32)),
                  const FeaturedTourSection(),

                  if (!isSearching) ...[
                    SizedBox(height: context.rh(32)),
                    const PromotionSection(),
                    SizedBox(height: context.rh(32)),
                    const AboutUsSection(),
                  ],

                  // Khoảng đệm trước Footer
                  SizedBox(height: context.rh(40)),
                ]),
              ),
            ),

            // ================= FOOTER =================
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}
