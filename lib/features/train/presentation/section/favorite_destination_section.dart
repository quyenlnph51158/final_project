import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../train/presentation/widgets/destination_card.dart';
import 'package:provider/provider.dart';

class FavoriteDestinationSection extends StatelessWidget {
  const FavoriteDestinationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng watch để UI tự động rebuild khi danh sách destinations thay đổi
    final controller = context.watch<TrainController>();
    final l10n = AppLocalizations.of(context)!;

    // Lấy danh sách đã lọc
    final destinations = controller.state.data.destinations
        .where((a) => a.fileLink != null && a.description != null)
        .take(5)
        .toList();

    // Nếu không có dữ liệu thì không chiếm không gian
    if (destinations.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      // Thay h(3) bằng rh(24) để padding dọc ổn định trên mọi chiều dài màn hình
      padding: EdgeInsets.symmetric(vertical: context.rh(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TIÊU ĐỀ SECTION
          Padding(
            // Sử dụng context.padding để thẳng hàng tuyệt đối với các phần khác
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Text(
              l10n.favorite_destinations,
              textAlign: TextAlign.center,
              style: TextStyle(
                // Sử dụng sp(20) kèm clamp giúp font không bị quá to trên máy nhỏ
                fontSize: context.sp(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D2939),
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Thay h(3) bằng rh(20) cho khoảng nghỉ sau tiêu đề
          SizedBox(height: context.rh(20)),

          // 2. DANH SÁCH CÁC ĐỊA ĐIỂM
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Column(
              children: destinations.map((destination) {
                return DestinationCard(
                  imageUrl: destination.fileLink!,
                  title: destination.title ?? '',
                  description: destination.description ?? '',
                );
              }).toList(),
            ),
          ),

          // Thay h(2) bằng rh(8) để khoảng đệm cuối section tinh tế hơn
          SizedBox(height: context.rh(8)),
        ],
      ),
    );
  }
}
