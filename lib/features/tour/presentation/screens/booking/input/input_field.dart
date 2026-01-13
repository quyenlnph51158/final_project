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
        prefixIcon:
        const Icon(Icons.location_city_outlined, color: kPrimaryColor),
        filled: true,
        fillColor: kFormFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorderColor),
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}