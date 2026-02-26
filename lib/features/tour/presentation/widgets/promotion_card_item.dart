import 'package:final_project/core/data/model/promotion_model.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';


class PromotionCardItem extends StatelessWidget{
  final PromotionModel promotionData;
  const PromotionCardItem({super.key,
    required this.promotionData,
  });
  @override
  Widget build(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //       content:
          //       Text('${l10n.home_promotionSnackbar} ${promotionData['title']}')),
          // );
        },
        child: Container(
          height: AppSizes.promotionItem,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(promotionData.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: AppLayoutSpacing.paddingPromotionCardItem,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      promotionData.title,
                      style: AppStyles.promotionTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (promotionData.discount != null) ...[
                      AppLayoutSpacing.titleAndDiscountValue,
                      Text(
                        promotionData.discount,
                        style: AppStyles.promotionDiscountValue,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
