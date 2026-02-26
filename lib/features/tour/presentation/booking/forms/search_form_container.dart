import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/features/tour/presentation/booking/forms/tour_search_form.dart';
import 'package:final_project/features/tour/presentation/booking/forms/train_search_form.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    switch (selectedTab) {
      case TravelTab.flight:
        currentForm = FlightSearchForm(
          onSearch: () {
            context.read<TravelBookingController>().performFlightSearch(l10n);
          },
        );
        break;
      case TravelTab.train:
        currentForm = const TrainSearchForm();
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
      padding: AppLayoutSpacing.paddingForm,
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
          AppLayoutSpacing.tabAndForm,
          currentForm,
        ],
      ),
    );
  }
}
