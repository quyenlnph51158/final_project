import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';


class DateField extends StatelessWidget{
  final String label;
  final String hintText;
  final String value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: kFormFieldBackground,
          border: AppShape.selectionField,
          labelStyle: TextStyle(fontSize: context.sp(16))
        ),
        child: Text(
          hasValue ? value! : hintText, // 👈 nếu chưa có thì hiện chữ mờ
          style: TextStyle(
            color: hasValue
                ? kTextColor
                : kNullValue, // 👈 chữ mờ
            fontSize: context.sp(14)
          ),
        ),
      ),
    );
  }
}