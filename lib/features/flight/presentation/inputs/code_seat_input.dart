import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

class CodeSeatInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const CodeSeatInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmail =
    label.toLowerCase().contains('email');

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          isEmail ? Icons.email_outlined : Icons.tag_outlined,
          color: kPrimaryColor,
        ),
        filled: true,
        fillColor: kFormFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorderColor),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}
