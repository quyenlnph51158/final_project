import 'package:final_project/core/data/constants/promotion_data.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../widgets/promotion_card_item.dart';
class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});
  @override
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_promotionSectionVibes,
              style:  GoogleFonts.bonheurRoyale(
                fontSize: context.sp(40),
                color: const Color(0xFF00796B),
              ),
            ),
          ),
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: TextStyle(
                fontSize: context.sp(28),
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
            ),
          ),
          SizedBox(height: context.rh(16)),
          ...PromotionData.promotions.map((promotion) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.rh(24)),
              child: PromotionCardItem(promotionData:promotion),
            );
          }).toList(),
        ],
      ),
    );
  }
}