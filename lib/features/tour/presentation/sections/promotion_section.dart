import 'package:final_project/core/data/constants/promotion_data.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../widgets/promotion_card_item.dart';
class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});
  @override
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: AppLayoutSpacing.paddingPromotionSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_promotionSectionVibes,
              style: AppStyles.promotionSectionVibe,
            ),
          ),
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: AppStyles.promotionSectionTitle,
            ),
          ),
          AppLayoutSpacing.titleAndPromotionCard,
          ...PromotionData.promotions.map((promotion) {
            return Padding(
              padding: AppLayoutSpacing.paddingBottomPromotionCard,
              child: PromotionCardItem(promotionData:promotion),
            );
          }).toList(),
        ],
      ),
    );
  }
}