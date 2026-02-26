import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';

class FlightTrainLocationInput extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final String? hint;

  const FlightTrainLocationInput({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.hint
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != " ()" && value!.isNotEmpty;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: kFormFieldBackground,
          border: AppShape.selectionField,
          labelStyle: TextStyle(fontSize: context.sp(16)),
        ),
        child: Text(
          hasValue ? value! : hint.toString(), // 👈 nếu chưa có thì hiện chữ mờ
          style: TextStyle(
            color: hasValue
                ? kTextColor
                : kNullValue, // 👈 chữ mờ
            fontSize: context.sp(14),
          ),
        ),
      ),
    );

  }
}
