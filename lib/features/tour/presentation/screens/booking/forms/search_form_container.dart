import 'package:final_project/features/tour/presentation/screens/booking/forms/tour_search_form.dart';
import 'package:final_project/features/tour/presentation/screens/booking/forms/train_search_form.dart';
import '../../../../../../../core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/travel_booking_tab.dart';
import 'flight_search_form.dart';

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
        currentForm = const FlightSearchForm();
        break;
      case TravelTab.train:
        currentForm = const TrainSearchForm();
        break;
      case TravelTab.tour:
        currentForm = const TourSearchForm();
        break;
    }

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TravelBookingTab(),
          const SizedBox(height: 16),
          currentForm,
        ],
      ),
    );
  }
}
