import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../widgets/promotion_card.dart';
import 'package:provider/provider.dart';

class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng watch để UI cập nhật khi dữ liệu cheapJourneys thay đổi
    final controller = context.watch<TrainController>();
    final l10n = AppLocalizations.of(context)!;
    final cheapJourneys = controller.state.data.cheapJourneys;

    // Nếu không có dữ liệu, không hiển thị cả section để tránh khoảng trắng thừa
    if (cheapJourneys.isEmpty) return const SizedBox.shrink();

    return Container(
      // Màu nền xám nhạt đồng bộ với thiết kế hiện đại
      color: const Color(0xFFF2F4F7),
      width: double.infinity,
      // Thay h(4) bằng rh(32) để padding dọc ổn định theo tỷ lệ pixel
      padding: EdgeInsets.symmetric(vertical: context.rh(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TIÊU ĐỀ SECTION
          Padding(
            // Sử dụng context.padding để lề trái phải thẳng hàng với toàn app
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Text(
              l10n.cheap_trips_offers,
              textAlign: TextAlign.center,
              style: TextStyle(
                // Font size sp() đã có clamp nên rất an toàn trên máy thật
                fontSize: context.sp(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D2939),
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Thay h(3) bằng rh(24) cho khoảng nghỉ sau tiêu đề
          SizedBox(height: context.rh(24)),

          // 2. DANH SÁCH PROMOTION CARDS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Column(
              children: cheapJourneys.map((cheapJourney) {
                return PromotionCard(
                  imageUrl: cheapJourney.fileLink ?? '',
                  route: cheapJourney.title ?? '',
                  price: cheapJourney.extensions ?? '',
                );
              }).toList(),
            ),
          ),

          // Tăng khoảng đệm nhẹ ở cuối section bằng rh
          SizedBox(height: context.rh(8)),
        ],
      ),
    );
  }
}
