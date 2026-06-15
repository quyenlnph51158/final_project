import 'package:final_project/core/data/model/promotion_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_layout.dart';


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
          height: context.rh(240),
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
            padding: EdgeInsets.all(context.rw(16)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      promotionData.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(20),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (promotionData.discount != null) ...[
                      SizedBox(height: context.rh(8)),
                      Text(
                        promotionData.discount,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(32),
                          fontWeight: FontWeight.w900,
                        ),
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
