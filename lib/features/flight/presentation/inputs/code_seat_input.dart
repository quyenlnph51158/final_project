import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

import '../../../../core/design/flight/flight_shape.dart';
import '../../../../core/design/flight/flight_style.dart';

class CodeSeatInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isEmail;

  const CodeSeatInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.isEmail,
  });

  @override
  Widget build(BuildContext context) {
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
        border: FlightShape.inputOutlineBorder(context),
      ),
      style: FlightStyle.inputFieldText(context),
    );
  }
}
