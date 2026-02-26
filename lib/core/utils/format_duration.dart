import '../../app/l10n/app_localizations.dart';

class FormatDuration {
  static String formatDuration(int minutes, AppLocalizations l10n) {
    if (minutes < 60) {
      return l10n.flight_results_duration_min(minutes);
    }

    final hours = minutes ~/ 60;
    final remain = minutes % 60;

    if (remain == 0) {
      return '${hours}h';
    }

    return l10n.flight_results_duration_hour(hours, remain);
  }
}