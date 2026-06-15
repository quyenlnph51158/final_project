import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';

class PassengerInputField extends StatelessWidget {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final VoidCallback onTap;

  const PassengerInputField({
    super.key,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int totalPassengers = adultCount + childCount;

    // Logic xây dựng chuỗi hiển thị
    String textToShow = '$totalPassengers ${l10n.general_totalPassengers}';
    if (infantCount > 0) {
      textToShow += ' (+$infantCount ${l10n.form_labelInfant})';
    }

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.general_passengerLabel,
          filled: true,
          fillColor: kFormFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kFormBackgroundColor),
          ),
          labelStyle: TextStyle(fontSize: context.sp(16), color: Colors.grey.shade700),
        ),
        child: Text(
          textToShow,
          style: TextStyle(fontSize: context.sp(14), color: kTextColor),
        ),
      ),
    );
  }
}