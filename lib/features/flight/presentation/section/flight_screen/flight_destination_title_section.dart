import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart';

class FlightDestinationTitleSection extends StatelessWidget {
  const FlightDestinationTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: context.rh(32)),
          Text(
            l10n.flight_screen_top_destinations,
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.rh(16)),
        ],
      ),
    );
  }
}
