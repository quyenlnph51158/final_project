import 'package:final_project/core/data/model/home_tour_model.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/features/tour/presentation/sections/list_tour_section.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../booking/forms/tour_search_form.dart';
import '../controller/travel_booking_controller.dart';
import '../sections/featured_tour_section.dart';
import '../state/travel_filter_state.dart';
import '../widgets/header/booking_header.dart';
import '../widgets/header/header_back_ground.dart';

class TourScreen extends StatefulWidget {
  final HomeTourData? homeData;
  const TourScreen({
    super.key,
    this.homeData
  });
  @override
  State<TourScreen> createState() => _TourScreen();
}
class _TourScreen extends State<TourScreen> {
  final GlobalKey _resultKey = GlobalKey();
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();
      controller.resetToInitial();
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
      if(widget.homeData!=null){

      }
    });
    _resultKey;
  }
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    // Tính toán chiều cao linh hoạt cho Stack
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    const double extraContentHeight = 300;
    final double containerHeight = headerHeight  + extraContentHeight;


    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: AppDrawer(
        onTabSelected: controller.updateTab,
        onHomeSelected: controller.resetSearch,
        onTabFlightSelected: (_) =>
            controller.updateTab(TravelTab.flight),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
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
                        padding: AppLayoutSpacing.paddingForm,
                        decoration: AppShape.boxForm,
                        child: TourSearchForm(
                          onSearch:() {
                            controller.performTourSearch(l10n.form_defaultDestination);
                            _scrollToResults();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppLayoutSpacing.section,
              ListTourSection(key: _resultKey,),
              AppLayoutSpacing.footer,
              // --- Footer ---
              const AppFooter(),
            ]
        ),
      ),
    );
  }
  void _scrollToResults() {
    // Đợi một chút để UI có thời gian cập nhật dữ liệu mới nếu cần
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _resultKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}