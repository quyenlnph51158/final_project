import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/data/constants/extra_service_data.dart';
import '../../../../shared/footer/app_footer.dart';
import '../../../../shared/header/app_drawer.dart';
import '../controller/flight_controller.dart';
import '../section/flight_screen/extra_service_section.dart';
import '../section/flight_screen/feature_section.dart';
import '../section/flight_screen/featured_list_cheap_flight_section.dart';
import '../section/flight_screen/featured_list_cheap_flight_title_section.dart';
import '../section/flight_screen/flight_destination_grid_section.dart';
import '../section/flight_screen/flight_destination_title_section.dart';
import '../section/flight_screen/header_section.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<FlightController>();
      controller.resetToInitial();
      controller.initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FlightController>();
    final scrollController = controller.scrollController;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        if(didPop) return;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        endDrawer: AppDrawer(
          onTabSelected: (_) =>
              controller.updateTab(FlightTab.flight),
          onHomeSelected: controller.resetSearch,
          onTabFlightSelected: controller.updateTab,
        ),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            /// HEADER
            SliverToBoxAdapter(
              child: FlightHeaderSection(),
            ),
                /// FEATURE
            SliverToBoxAdapter(
                  child: FlightFeatureSection(),
                ),
                const FlightDestinationTitleSection(),
                FlightDestinationGridSection(),
                const FeaturedListCheapFlightTitleSection(),
                SliverToBoxAdapter(
                  child: FeaturedListCheapFlightSection(),
                ),
                SliverToBoxAdapter(
                  child: ExtraSection(ExtraService: ExtraServiceData.extraServices,),
                ),
                SliverToBoxAdapter(
                  child: AppFooter(),
                )
              ]
          ),

      )
    );
  }
}
