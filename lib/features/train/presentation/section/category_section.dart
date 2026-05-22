import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../widgets/category_card.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Danh sách dữ liệu mẫu
    final List<Map<String, String>> categories = [
      {
        'title': l10n.best_seller,
        'imageUrl':
            'https://www.wonderingvietnam.com/assets/img/train/cau-vang.png',
      },
      {
        'title': l10n.tour_activities,
        'imageUrl':
            'https://www.wonderingvietnam.com/assets/img/train/cau-vang.png',
      },
      {
        'title': l10n.best_hotel,
        'imageUrl':
            'https://www.wonderingvietnam.com/assets/img/train/son-nui.png',
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Khoảng cách phía trên Section
          // Thay h(4) bằng rh(32) để khoảng cách luôn vừa vặn trên mọi chiều dài màn hình
          SizedBox(height: context.rh(32)),

          // 2. Render danh sách Category Cards
          Padding(
            // Sử dụng context.padding (đã được rw) để thẳng hàng với các section khác
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Column(
              children: categories.map((item) {
                return Padding(
                  // Thay h(2.5) bằng rh(16) cho khoảng cách giữa các card ổn định
                  padding: EdgeInsets.only(bottom: context.rh(16)),
                  child: CategoryCard(
                    title: item['title']!,
                    imageUrl: item['imageUrl']!,
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Khoảng cách an toàn phía dưới Section
          // Thay h(2) bằng rh(16)
          SizedBox(height: context.rh(16)),
        ],
      ),
    );
  }
}
