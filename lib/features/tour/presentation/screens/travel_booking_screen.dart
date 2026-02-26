import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../booking/forms/search_form_container.dart';
import '../controller/travel_booking_controller.dart';
import '../sections/about_us_section.dart';
import '../sections/featured_tour_section.dart';
import '../sections/featured_destinations_section.dart';
import '../sections/header_section.dart';
import '../sections/promotion_section.dart';
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
    // ✅ GỌI initData TỪ PROVIDER ĐÃ TỒN TẠI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();
      controller.resetToHome();
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture,l10n.form_defaultDestination);

    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final state = controller.state;

    final double headerHeight =
        MediaQuery.of(context).size.height * 0.35;

    final selectedTab = state.ui.selectedTab;
    return Scaffold(
      backgroundColor: kFormBackgroundColor,
      endDrawer: AppDrawer(
        onTabSelected: controller.updateTab,
        onHomeSelected: controller.resetSearch,
        onTabFlightSelected: (_) =>
            controller.updateTab(TravelTab.flight),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= HEADER =================
            SizedBox(
              height: state.ui.selectedTab==TravelTab.tour ? headerHeight+380 : headerHeight+500 ,
              child: Stack(
                children: [
                  HeaderBackground(height: headerHeight),
                  HeaderSection(),
                  Positioned(
                    top: headerHeight - 15,
                    left: 16,
                    right: 16,
                    child: SearchFormContainer(selectedTab: selectedTab),

                  ),
                ],
              ),
            ),
            // ================= FEATURED DESTINATIONS =================
            if (!state.ui.isSearching) ...[
              AppLayoutSpacing.section,
              const FeaturedDestinationSection(),
            ],

            AppLayoutSpacing.section,

            // ================= FEATURED TOURS =================
            const FeaturedTourSection(),

            // ================= EXTRA SECTIONS =================
            if (!state.ui.isSearching) ...[
              AppLayoutSpacing.section,
              const PromotionSection(),
              AppLayoutSpacing.section,
              const AboutUsSection(),
            ],
            AppLayoutSpacing.footer,
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
