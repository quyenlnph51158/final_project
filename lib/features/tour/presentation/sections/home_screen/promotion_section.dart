import 'package:final_project/core/data/constants/promotion_data.dart';
import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../widgets/promotion_card_item.dart';
class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});
  @override
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: TourLayoutSpacing.paddingPromotionSection(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_promotionSectionVibes,
              style: AppStyles.promotionSectionVibe(context),
            ),
          ),
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: AppStyles.promotionSectionTitle(context),
            ),
          ),
          TourLayoutSpacing.titleAndPromotionCard,
          ...PromotionData.promotions.map((promotion) {
            return Padding(
              padding: TourLayoutSpacing.paddingBottomPromotionCard(context),
              child: PromotionCardItem(promotionData:promotion),
            );
          }).toList(),
        ],
      ),
    );
  }
}