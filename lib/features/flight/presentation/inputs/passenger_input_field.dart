import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../core/design/flight/flight_style.dart';

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
          border: AppShape.selectionField,
          labelStyle: FlightStyle.labelField(context),
        ),
        child: Text(
          textToShow,
          style: AppStyles.textValue(context),
        ),
      ),
    );
  }
}