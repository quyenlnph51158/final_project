import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/data/models/tour_detail.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HighlightSection extends StatelessWidget{
  final TourDetail detail;
  const HighlightSection({super.key,
    required this.detail
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (detail.extensions == null || detail.extensions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: AppLayoutSpacing.paddingHighLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tour_detail_highlights,
            style: AppStyles.hightLightTitle,
          ),
          AppLayoutSpacing.labelandcontent,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detail.extensions.map((highlight) {
              return Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppLayoutSpacing.iconHighLight,
                      child: AppIcons.check_circle,
                    ),
                    Expanded(
                      child: Text(
                        highlight,
                        style: AppStyles.hightLightContent,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}