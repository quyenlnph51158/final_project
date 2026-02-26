import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
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
        ),
        child: Text(
          hasValue ? value! : hintText, // 👈 nếu chưa có thì hiện chữ mờ
          style: TextStyle(
            color: hasValue
                ? kTextColor
                : kNullValue, // 👈 chữ mờ
          ),
        ),
      ),
    );
  }
}