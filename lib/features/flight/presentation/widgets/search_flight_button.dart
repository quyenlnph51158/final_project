import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../controller/flight_controller.dart';

class SearchFlightButton extends StatelessWidget{
  final String text;
  const SearchFlightButton({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.read<FlightController>();
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.search, color: Colors.white),
        label: Text(
          text,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (controller.state.selectedFlightTab == FlightTab.flight) {
            controller.navigateToFlightResults(context);
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