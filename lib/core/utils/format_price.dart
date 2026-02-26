import 'package:intl/intl.dart';

class FormatPrice {
  static String formatPrice(num value) {
    try {
      return NumberFormat('#,###').format(value);
    } catch (_) {
      return '0';
    }
  }
}