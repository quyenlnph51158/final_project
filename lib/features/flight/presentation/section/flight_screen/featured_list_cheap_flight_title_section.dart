import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/shared/app_style.dart';

class FeaturedListCheapFlightTitleSection extends StatelessWidget {
  const FeaturedListCheapFlightTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SharedAppLayoutSpacing.section,
          Text(
            l10n.flight_viewLatestDeals,
            style: SharedAppStyle.titleSection(context),
          ),
          SizedBox(height: context.hp(4)),
        ],
      ),
    );
  }
}