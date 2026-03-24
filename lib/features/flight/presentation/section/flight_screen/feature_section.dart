import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/shared/app_style.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../widgets/flight_screen/flight_feature_card.dart';

class FlightFeatureSection extends StatelessWidget {
  const FlightFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final cards = [
      FlightFeatureCard(
        icon: Icons.luggage_outlined,
        title: l10n.flight_feature_luggage_title,
        subtitle: l10n.flight_feature_luggage_sub,
      ),
      FlightFeatureCard(
        icon: Icons.flight_takeoff,
        title: l10n.flight_feature_online_checkin_title,
        subtitle: l10n.flight_feature_online_checkin_sub,
      ),
      FlightFeatureCard(
        icon: Icons.flight_rounded,
        title: l10n.flight_feature_checkin_available_title,
        subtitle: l10n.flight_feature_checkin_available_sub,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.sectionHorizontalPadding(context),
      ),
      child: Column(
        children: [
          Text(
            l10n.flight_screen_service_title,
            style: SharedAppStyle.titleSection(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: FlightLayoutSpacing.gapAfterSectionTitle(context)),
          Column(
            children: cards
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: FlightLayoutSpacing.gapBetweenFeatures,
                    ),
                    child: c,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
