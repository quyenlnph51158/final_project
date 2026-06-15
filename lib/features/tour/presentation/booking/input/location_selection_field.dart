import 'package:final_project/core/utils/responsive_layout.dart';
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kFormBackgroundColor),
          ),
          labelStyle:TextStyle(fontSize: context.sp(16)),
        ),
        child: selectedDestination != null
            ? Row(
          children: [
            SizedBox(height: context.rw(12)),
            Expanded(
              child: Text(
                selectedDestination.label,
                style: TextStyle(fontSize: context.sp(14), color: kTextColor)
              ),
            ),
          ],
        )
            : Text(l10n.form_defaultReturnDate, style: TextStyle(fontSize: context.sp(14), color: Colors.black54),
        ),
      ),
    );
  }
}
