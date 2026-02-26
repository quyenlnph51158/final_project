import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/app/l10n/app_localizations_en.dart';
import 'package:final_project/core/design/flight/flight_shape.dart';
import 'package:final_project/core/design/flight/flight_size.dart';
import 'package:final_project/core/design/flight/flight_style.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        minimumSize: Size(double.infinity, FlightSize.btnContinueHeight(context)),
        shape: RoundedRectangleBorder(borderRadius: FlightShape.borderRadiusSmall(context)),
      ),
      child: Text(
        l10n.text_btnContinue,
        style: FlightStyle.buttonLarge(context),
      ),
    );
  }
}