import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const InputField({
  super.key,
  required this.label,
  required this.hint,
  required this.controller,});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: kFormFieldBackground,
        border: AppShape.selectionField,

      ),
      style: AppStyles.textValue,
    );
  }
}