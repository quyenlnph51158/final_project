import 'package:final_project/app/l10n/app_localizations.dart';
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
        minimumSize: Size(double.infinity, context.rh(48).clamp(45.0, 55.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.sp(8))),
      ),
      child: Text(
        l10n.text_btnContinue,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: context.sp(20), // Áp dụng responsive cho font size
        ),
      ),
    );
  }
}