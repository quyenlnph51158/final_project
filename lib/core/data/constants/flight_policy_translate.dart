import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';

class FlightPolicyTranslate {
  static String getTranslation(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      case "policy_carryOnBaggage":
        return l10n.policy_carryOnBaggage; // Key trong file .arb của bạn
      case "policy_changeFlight":
        return l10n.policy_changeFlight;
      case "policy_refund":
        return l10n.policy_refund;
      default:
        return key; // Trả về chính nó nếu không tìm thấy
    }
  }

  // Tiện ích để lấy luôn Icon theo Key
  static IconData getIcon(String key) {
    switch (key) {
      case "policy_carryOnBaggage":
        return Icons.luggage_outlined;
      case "policy_changeFlight":
        return Icons.published_with_changes_rounded;
      case "policy_refund":
        return Icons.refresh_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}