import 'package:final_project/features/tour/presentation/screens/sections/related_tour_section.dart';
import 'package:final_project/features/tour/presentation/screens/sections/review_section.dart';
import 'package:final_project/features/tour/presentation/screens/sections/schedule_section.dart';
import 'package:final_project/features/tour/presentation/screens/widgets/header/headerBackgound.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'booking/forms/consultation_form_screen.dart';
import 'controller/travel_booking_controller.dart';
import 'sections/highlight_section.dart';
import 'sections/image_carousel_section.dart';

class TourDetailScreen extends StatefulWidget{
  final String name;
  final String location;
  final String date;
  const TourDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.date
  });
  @override
  State<TourDetailScreen> createState() => _TourDetailScreen();
}
class _TourDetailScreen extends State<TourDetailScreen> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      context.read<TravelBookingController>().fetchTourDetail(widget.name,l10n.error_dataLoadingFailed);
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
    });
  }
  @override
  Widget build(BuildContext context){
    final controller = context.read<TravelBookingController>();
    final state = context.watch<TravelBookingController>().state;
    final double headerHeight = MediaQuery
        .of(context)
        .size
        .height * 0.35;
    return Scaffold(
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
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  HeaderBackground(height: headerHeight,image: controller.state.tourDetail.image),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(),
                        const SizedBox(height: kToolbarHeight),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 1.0, right: 20.0),
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 30.0, right: 20.0, bottom: 20.0
              ),
              child: HtmlWidget(
                state.tourDetail.brief.toString(),
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                onTapUrl: (url) async {
                  return true;
                },
              ),
            ),
            SizedBox(height: 15,),
            HighlightSection(detail:  state.tourDetail),
            SizedBox(height: 15,),
            ScheduleSection(detail: state.tourDetail),
            SizedBox( height: 15,),
            ImageCarousel(tourDetail: state.tourDetail,),
            SizedBox(height: 48,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConsultationFormScreen(tourSid: state.tourDetail.sid,location: widget.location, date: widget.date),
                ),
              ),
            ),
            const SizedBox(height: 48,),
            ReviewSection(detail: state.tourDetail),
            SizedBox(height: 30,),
            RelatedTourSection(tourDetail: state.tourDetail,),
            SizedBox(height: 38,),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}

