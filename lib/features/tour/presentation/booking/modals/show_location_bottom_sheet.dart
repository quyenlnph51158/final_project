import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/features/tour/data/models/tour_destination.dart';
import 'package:flutter/material.dart';
import 'location_picker_sheet.dart';

Future<void> showLocationBottomSheet<T extends TourDestination>({
  required BuildContext context,
  required String title,
  required List<T> tourDestinations,
  required String? selectedValue,
  required ValueChanged<T> onSelected,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: kBackgroundColor ,
    shape: AppShape.selectList,
    builder: (_) => LocationPickerSheet<T>(
      title: title,
      tourDestinations: tourDestinations,
      selectedValue: selectedValue,
      onSelected: onSelected,
    ),
  );
}
