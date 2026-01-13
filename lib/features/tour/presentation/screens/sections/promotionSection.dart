import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../widgets/promotionCardItem.dart';
class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});
  static final _promotions = [
    {
      'title': 'Du Thuyền Với Bữa Tối Trên Tàu Saigon Princess',
      'image': 'https://www.wonderingvietnam.com/assets/img/common/deal_1.png',
      'discount': '15%',
      'type': 'cruise',
    },
    {
      'title': 'Phòng lưu trú tại Bakhan Resort và xe vận chuyển',
      'image': 'https://www.wonderingvietnam.com/assets/img/common/deal_2.png',
      'discount': '25%',
      'type': 'resort',
    },
    {
      'title': 'Khám phá Vịnh Hạ Long 2N1Đ trên Du thuyền',
      'image': 'https://www.wonderingvietnam.com/assets/img/common/deal_3.png',
      'discount': '20%',
      'type': 'cruise',
    },
  ];
  @override
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_promotionSectionVibes,
              style: TextStyle(
                fontFamily: 'GreatVibes',
                fontSize: 24,
                color: Color(0xFF00796B),
              ),
            ),
          ),
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._promotions.map((promotion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: PromotionCardItem(promotionData:promotion),
            );
          }).toList(),
        ],
      ),
    );
  }
}