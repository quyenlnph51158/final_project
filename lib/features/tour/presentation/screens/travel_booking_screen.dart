import 'package:final_project/features/tour/presentation/screens/sections/aboutUsSection.dart';
import 'package:final_project/features/tour/presentation/screens/sections/featuredTourSection.dart';
import 'package:final_project/features/tour/presentation/screens/sections/featured_destinations_section.dart';
import 'package:final_project/features/tour/presentation/screens/sections/headerSection.dart';
import 'package:final_project/features/tour/presentation/screens/sections/promotionSection.dart';
import 'package:final_project/features/tour/presentation/screens/widgets/header/headerBackgound.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import 'booking/forms/search_form_container.dart';
import 'controller/travel_booking_controller.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';

class TravelBookingScreen extends StatefulWidget {
  const TravelBookingScreen({super.key});

  @override
  State<TravelBookingScreen> createState() => _TravelBookingScreenState();
}

class _TravelBookingScreenState extends State<TravelBookingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ GỌI initData TỪ PROVIDER ĐÃ TỒN TẠI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();
      controller.resetToInitial();
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture,l10n.form_defaultDestination);

    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final state = controller.state;

    final double headerHeight =
        MediaQuery.of(context).size.height * 0.35;

    final selectedTab = state.selectedTab;
    return Scaffold(

      endDrawer: AppDrawer(
        onTabSelected: controller.updateTab,
        onHomeSelected: controller.resetSearch,
        onTabFlightSelected: (_) =>
            controller.updateTab(TravelTab.flight),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= HEADER =================
            SizedBox(
              height: headerHeight,
              child: Stack(
                children: [
                  HeaderBackground(height: headerHeight),
                  HeaderSection(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= SEARCH FORM =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchFormContainer(selectedTab: selectedTab),
            ),

            // ================= FEATURED DESTINATIONS =================
            if (!state.isSearching) ...[
              const SizedBox(height: 16),
              const FeaturedDestinationSection(),
            ],

            const SizedBox(height: 32),

            // ================= FEATURED TOURS =================
            const FeaturedTourSection(),

            // ================= EXTRA SECTIONS =================
            if (!state.isSearching) ...[
              const SizedBox(height: 32),
              const PromotionSection(),
              const SizedBox(height: 32),
              const AboutUsSection(),
            ],

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
