import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../controller/flight_controller.dart';

class SearchFlightButton extends StatelessWidget {
  final String text;

  const SearchFlightButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<FlightController>();
    return SizedBox(
      width: double.infinity,
      height: FlightSize.btnSearchHeight(context),
      child: ElevatedButton.icon(
        style: FlightStyle.searchFlightButton,
        icon: Icon(
          Icons.search,
          color: Colors.white,
          size: FlightSize.iconSizeMedium(context),
        ),
        label: Text(text, style: FlightStyle.buttonSearch),
        onPressed: () {
            controller.validateForm(l10n);
            if (controller.state.ui.errorMessage != '') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.state.ui.errorMessage),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              controller.navigateToFlightResults(context);
            }

        },
      ),
    );
  }
}
