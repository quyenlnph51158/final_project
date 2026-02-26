import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import '../../../../core/design/shared/app_layout_spacing.dart';
import '../../../../core/design/tour/tour_layout_spacing.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../flight/presentation/controller/flight_controller.dart';
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
      controller.resetToHome();
      controller.initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
      context.read<FlightController>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Use context.select for performance (only rebuild when these change)
    final selectedTab = context.select((TravelBookingController c) => c.state.ui.selectedTab);
    final isSearching = context.select((TravelBookingController c) => c.state.ui.isSearching);
    final scrollController = context.read<TravelBookingController>().scrollController;

    // 2. Responsive values using your Extension
    final bool isDesktop = context.isDesktop;
    final bool isTablet = context.isTablet;

    // Dynamic Header Calculations
    final double baseHeaderHeight = context.hp(isDesktop ? 40 : 35);

    // Calculate the overlap height for the search form based on device
    double searchFormHeight;
    if (selectedTab == TravelTab.tour) {
      searchFormHeight = isDesktop ? 300 : (isTablet ? 510 : 470);
    }
    else {
      searchFormHeight = isDesktop ? 400 : (isTablet ? 650 : 630);
    }

    final double totalHeaderStackHeight = baseHeaderHeight + (searchFormHeight * 0.8);

    // Dynamic horizontal padding
    final double horizontalPadding = isDesktop ? context.wp(15) : (isTablet ? 40 : 16);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        if(didPop) return;
      },
      child:Scaffold(
        backgroundColor: kFormBackgroundColor,
        endDrawer: AppDrawer(
          onTabSelected: context.read<TravelBookingController>().updateTab,
          onHomeSelected: context.read<TravelBookingController>().resetSearch,
          onTabFlightSelected: (_) => context.read<TravelBookingController>().updateTab(TravelTab.flight),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ================= RESPONSIVE HEADER =================
              SizedBox(
                height: totalHeaderStackHeight,
                child: Stack(
                  children: [
                    HeaderBackground(height: baseHeaderHeight),
                    const HeaderSection(),
                    Positioned(
                      top: baseHeaderHeight - (isDesktop ? 60 : 30), // Pull form up into the blue background
                      left: horizontalPadding,
                      right: horizontalPadding,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? 1100 : 800, // Limit width on very large screens
                          ),
                          child: SearchFormContainer(selectedTab: selectedTab),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= CONTENT SECTIONS =================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    if (!isSearching) ...[
                      SharedAppLayoutSpacing.section,
                      const FeaturedDestinationSection(),
                    ],

                    SharedAppLayoutSpacing.section,
                    const FeaturedTourSection(),

                    if (!isSearching) ...[
                      SharedAppLayoutSpacing.section,
                      const PromotionSection(),
                      SharedAppLayoutSpacing.section,
                      const AboutUsSection(),
                    ],
                  ],
                ),
              ),

              SharedAppLayoutSpacing.footer,
              const AppFooter(),
            ],
          ),
        ),
      )
    );
  }
}