import 'package:final_project/core/utils/format_date.dart';
import 'package:flutter/material.dart';

class DatePicker{
  static Future<void> pickDate({
    required BuildContext context,
    required Function(String formattedDate, DateTime originalDate) onDateSelected,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(3000),
    );

    if (picked != null) {
      // Logic định dạng ngày: dd-mm-yyyy
      final formatted = FormatDate.formatDateDDMMYYYY(picked);

      // Trả kết quả về thông qua callback
      onDateSelected(formatted, picked);
    }

  }
}