import 'package:flutter/material.dart';

class DatePicker{
  static Future<DateTime?> pickDate(
      BuildContext context, {
        DateTime? initialDate,
        DateTime? firstDate,
        DateTime? lastDate,
      }) {
    final now = DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(2030),
    );
  }
}