import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
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
      height: AppSizes.searchButton,
      child: ElevatedButton.icon(
        style: AppStyles.searchButton,
        icon: AppIcons.iconSearch,
        label: Text(
          text,
          style: AppStyles.textSearchButton,
        ),
        onPressed: () {
          controller.performTourSearch(l10n.form_defaultDestination);
        },
      ),
    );
  }
}
