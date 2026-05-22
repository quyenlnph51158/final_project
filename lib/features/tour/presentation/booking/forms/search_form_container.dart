import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/features/flight/presentation/form/flight_form.dart';
import 'package:final_project/features/tour/presentation/booking/forms/tour_search_form.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:final_project/features/train/presentation/form/train_form.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/design/shared/app_layout_spacing.dart';
import '../widgets/travel_booking_tab.dart';

class SearchFormContainer extends StatelessWidget {
  final TravelTab selectedTab;

  const SearchFormContainer({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentForm;
    switch (selectedTab) {
      case TravelTab.flight:
        currentForm = FlightForm();
        break;
      case TravelTab.train:
        currentForm = TrainForm();
        break;
      case TravelTab.tour:
        currentForm = TourSearchForm(
          onSearch:() {
            context.read<TravelBookingController>().goToTourScreen();
          },
        );
        break;
    }

    return Container(
      padding: SharedAppLayoutSpacing.paddingForm,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TravelBookingTab(),
          SizedBox(height: TourLayoutSpacing.tabAndForm(context)),
          currentForm,
        ],
      ),
    );
  }
}
