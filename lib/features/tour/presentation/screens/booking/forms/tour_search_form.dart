import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../controller/travel_booking_controller.dart';
import '../input/date_field.dart';
import '../input/input_field.dart';
import '../input/location_selection_field.dart';
import '../widgets/search_button.dart';

class TourSearchForm extends StatelessWidget{
  const TourSearchForm({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    return Column(
      children: [
        LocationSelectionField(
           label:  l10n.form_defaultDestination, currentValue:  controller.state.tempDestination),
        const SizedBox(height: 12),
        DateField(label: l10n.form_labelDepartureDate,
          value: controller.state.selectedDate,
          onTap: () {
            controller.selectDate(context, isReturnDate: false);
          },),
        const SizedBox(height: 12),
        InputField(label: l10n.form_labelDeparturePlace,hint:  l10n.form_defaultDeparture,controller: controller.departureController),
        const SizedBox(height: 20),
        SearchButton(text: l10n.form_searchTourButton,),
      ],
    );
  }
}