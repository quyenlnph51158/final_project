import 'package:flutter/cupertino.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateField extends StatelessWidget{
  final String label;
  final String value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: kPrimaryColor,
          ),
          filled: true,
          fillColor: kFormFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kBorderColor),
          ),
        ),
        child: Text(value),
      ),
    );
  }
}