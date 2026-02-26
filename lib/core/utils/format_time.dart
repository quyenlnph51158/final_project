import 'package:intl/intl.dart';

class FormatTime {
  static String formatHHmmFromIso(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return '--:--';
    }
  }
}