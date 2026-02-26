import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../data/models/tour_destination.dart';
import '../../controller/travel_booking_controller.dart';
import '../modals/show_location_bottom_sheet.dart';

class LocationSelectionField extends StatelessWidget{
  final String label;
  final String currentValue;
  const LocationSelectionField({
    super.key,
    required this.label,
    required this.currentValue,
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    final bool isDestinationSelected =
    controller.state.tour.destinations.any((dest) => dest.label == currentValue);

    final TourDestination? selectedDestination = isDestinationSelected
        ? controller.state.tour.destinations.firstWhere((dest) => dest.label == currentValue)
        : null;
    return InkWell(
      onTap: () => showLocationBottomSheet<TourDestination>(
        context: context,
        title: l10n.form_modalSelectDestination,
        tourDestinations: controller.state.tour.destinations,
        selectedValue: currentValue,
        onSelected: (destination) {
          controller.selectDestinationFromModal(destination.label);
        },
      ),

      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: kFormFieldBackground,
          border: AppShape.selectionField,
        ),
        child: selectedDestination != null
            ? Row(
          children: [

            AppLayoutSpacing.valueInField,
            Expanded(
              child: Text(
                selectedDestination.label,
                style: AppStyles.textValue
              ),
            ),
          ],
        )
            : Text(
          l10n.form_defaultReturnDate,
          style: AppStyles.hintText,
        ),
      ),
    );
  }
}
