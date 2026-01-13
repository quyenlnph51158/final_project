import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../controller/travel_booking_controller.dart';

class SearchButton extends StatelessWidget{
  final String text;
  const SearchButton({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.search, color: Colors.white),
        label: Text(
          text,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          print("${controller.state.departure} - ${controller.state.destination}");
          if (controller.state.selectedTab == TravelTab.tour) {
            controller.performTourSearch(l10n.form_defaultDestination);
          } else if (controller.state.selectedTab == TravelTab.flight) {
            controller.performFlightSearch(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.home_trainSearchSnackbar)),
            );
          }
        },
      ),
    );
  }
}
