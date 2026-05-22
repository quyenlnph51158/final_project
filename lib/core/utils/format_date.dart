import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDate {
  static String formatDateDDMMYYYY(DateTime dateString) {
    try {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(dateString).toString();
    } catch (e) {
      return "";
    }
  }
  /// Chuyển ngược từ String (dd-MM-yyyy) về DateTime
  static DateTime? parseStringToDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      // Đảm bảo pattern khớp chính xác với định dạng bạn đang lưu
      return DateFormat('dd-MM-yyyy').parse(dateString);
    } catch (e) {
      debugPrint("Lỗi parse ngày: $e");
      return null;
    }
  }
  static String? parseStringToDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      // Đảm bảo pattern khớp chính xác với định dạng bạn đang lưu
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateString)).toString();
    } catch (e) {
      debugPrint("Lỗi parse ngày: $e");
      return null;
    }
  }
  static String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      return DateFormat('dd/MM/yyyy | HH:mm').format(
        DateTime.parse(date).toLocal(),
      );
    } catch (e) {
      return '';
    }
  }
}