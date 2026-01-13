import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';

class PassengerInputField extends StatelessWidget {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final String selectedClass;
  final VoidCallback onTap;

  const PassengerInputField({
    super.key,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.selectedClass,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int totalPassengers = adultCount + childCount;

    // Logic xây dựng chuỗi hiển thị
    String textToShow = '$totalPassengers ${l10n.general_totalPassengers}, $selectedClass';
    if (infantCount > 0) {
      textToShow += ' (+$infantCount ${l10n.form_labelInfant})';
    }

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.general_passengerLabel,
          prefixIcon: const Icon(Icons.person_outline, color: kPrimaryColor),
          filled: true,
          fillColor: const Color(0xFFF5F5F5), // Thay bằng kFormFieldBackground của bạn
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kBorderColor),
          ),
        ),
        child: Text(
          textToShow,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}