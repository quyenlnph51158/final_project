import 'package:final_project/features/tour/data/models/tour_detail.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/travel_booking_controller.dart';
import '../../widgets/tour_card_item.dart';

class RelatedTourSection extends StatelessWidget {
  final TourDetail tourDetail;

  const RelatedTourSection({super.key, required this.tourDetail});

  @override
  Widget build(BuildContext context) {
    // Chỉ lắng nghe danh sách tour ban đầu để tối ưu render
    final tours = context.select<TravelBookingController, List<TourItem>>(
      (c) => c.state.tour.initialList,
    );

    final l10n = AppLocalizations.of(context)!;

    // Lấy danh sách tour liên quan
    final relatedTours = tours
        .where((tour) => tour.id != tourDetail.id && tour.avarageRating == 5)
        .take(5)
        .toList();

    if (relatedTours.isEmpty) return const SizedBox.shrink();

    return Padding(
      // Sử dụng lề ngang chuẩn của hệ thống (12 hoặc 16px đã qua rw)
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TIÊU ĐỀ PHẦN
          Center(
            child: Text(
              l10n.tour_detail_you_should_consult,
              textAlign: TextAlign.center,
              style: TextStyle(
                // Sử dụng sp() để font chữ không bị tràn trên máy thật
                fontSize: context.sp(18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D2939),
              ),
            ),
          ),

          // Thay h(2.5) bằng rh(20) để khoảng cách dọc ổn định
          SizedBox(height: context.rh(20)),

          // 2. DANH SÁCH TOUR LIÊN QUAN
          Column(
            children: relatedTours.map((tour) {
              return Padding(
                // Thay h(2) bằng rh(16) cho khoảng cách giữa các card
                padding: EdgeInsets.only(bottom: context.rh(16)),
                child: TourCardItem(tour: tour),
              );
            }).toList(),
          ),

          // Khoảng đệm an toàn dưới cùng dựa trên rh
          SizedBox(height: context.rh(8)),
        ],
      ),
    );
  }
}
