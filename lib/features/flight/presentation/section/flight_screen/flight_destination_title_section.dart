import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/shared/app_style.dart';

class FlightDestinationTitleSection extends StatelessWidget {
  const FlightDestinationTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SharedAppLayoutSpacing.section,
          Text(
            l10n.flight_screen_top_destinations,
            style: SharedAppStyle.titleSection(context),
            textAlign: TextAlign.center,
          ),
          SharedAppLayoutSpacing.labelandCard,
        ],
      ),
    );
  }
}
