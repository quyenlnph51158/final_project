import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  const InputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: kFormFieldBackground,
        border: AppShape.selectionField,
        labelStyle: TextStyle(fontSize: context.sp(16)),
        hintStyle: TextStyle(fontSize: context.sp(14), color: kHintTextColor),
      ),
      style: AppStyles.textValue(context),
    );
  }
}