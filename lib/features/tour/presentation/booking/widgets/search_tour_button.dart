import 'package:final_project/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/travel_booking_controller.dart';

class SearchTourButton extends StatelessWidget{
  final String text;
  const SearchTourButton({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.read<TravelBookingController>();
    return SizedBox(
      width: double.infinity,
      height: context.rh(50),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: AppIcons.iconSearch,
        label: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          controller.performTourSearch(l10n.form_defaultDestination);
        },
      ),
    );
  }
}
