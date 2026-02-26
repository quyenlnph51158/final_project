import 'package:intl/intl.dart';

class FormatDate {
  static String? formatDateDDMMYYYY(DateTime dateString) {
    try {
      final formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(dateString).toString();
    } catch (e) {
      return null;
    }
  }
}