import 'package:final_project/features/tour/presentation/screens/sections/featuredTourSection.dart';
import 'package:final_project/features/tour/presentation/screens/widgets/header/booking_header.dart';
import 'package:final_project/features/tour/presentation/screens/widgets/header/headerBackgound.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'booking/forms/tour_search_form.dart';
import 'controller/travel_booking_controller.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});
  @override
  State<TourScreen> createState() => _TourScreen();
}
class _TourScreen extends State<TourScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();
      controller.resetToInitial();
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
    });
  }
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    // Tính toán chiều cao linh hoạt cho Stack
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    const double extraContentHeight = 300;
    final double containerHeight =
        headerHeight  + extraContentHeight;


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
            children: [
              SizedBox(
                height: containerHeight,
                child: Stack(
                  children: [
                    HeaderBackground(height: headerHeight,),
                    BookingHeader(),
                    Positioned(
                      top: headerHeight - 15,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kFormBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TourSearchForm(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              FeaturedTourSection(),
              const SizedBox(height: 60),
              // --- Footer ---
              const AppFooter(),
            ]
        ),
      ),
    );
  }
}