import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/core/utils/calculate_average_star.dart';
import 'package:final_project/features/tour/presentation/screens/review_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart'; // Import extension
import '../../../data/models/tour_detail.dart';
import '../../widgets/review_card.dart';

class ReviewSection extends StatefulWidget {
  final TourDetail detail;

  const ReviewSection({super.key, required this.detail});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Lấy tối đa 3 review đầu tiên
    final displayReviews = widget.detail.reviews.take(3).toList();
    final double averageRating = CalculateAverageStar.average(
      widget.detail.reviews,
    );

    return Padding(
      // Sử dụng lề ngang chuẩn hệ thống và lề dọc pixel-scale
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER: Tiêu đề "Đánh giá"
          Text(
            l10n.general_reviews,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D2939),
            ),
          ),

          // Thay h(1.5) bằng rh(12)
          SizedBox(height: context.rh(12)),

          // 2. RATING SUMMARY
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: context.sp(32),
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Padding(
                // Thay h(0.8) bằng rh(6)
                padding: EdgeInsets.only(bottom: context.rh(6)),
                child: Text(
                  ' /5',
                  style: TextStyle(
                    fontSize: context.sp(16),
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllReviewsScreen(
                        reviews: widget.detail.reviews,
                        averageRating: averageRating,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  l10n.tour_detail_read_all_reviews,
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          // 3. STARS & COUNT
          _buildStarRating(context, averageRating, size: 20),

          // Thay h(1) bằng rh(8)
          SizedBox(height: context.rh(8)),

          Text(
            '${l10n.tour_detail_based_on} ${widget.detail.reviews.length} ${l10n.tour_detail_reviews_count}',
            style: TextStyle(
              fontSize: context.sp(13),
              color: Colors.grey.shade600,
            ),
          ),

          // Thay h(3) bằng rh(24)
          SizedBox(height: context.rh(24)),

          // 4. LIST REVIEWS
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayReviews.length,
            // Thay h(2) bằng rh(16) cho khoảng cách giữa các card
            separatorBuilder: (context, index) =>
                SizedBox(height: context.rh(16)),
            itemBuilder: (context, index) {
              final review = displayReviews[index];

              return ReviewCard(
                width: double.infinity,
                child: Padding(
                  // Dùng rw để padding bên trong card ổn định
                  padding: EdgeInsets.all(context.rw(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review.name?.isNotEmpty ?? false)
                        Text(
                          review.name!,
                          style: TextStyle(
                            fontSize: context.sp(15),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D2D2D),
                          ),
                        ),

                      // Thay h(0.5) bằng rh(4)
                      SizedBox(height: context.rh(4)),

                      _buildStarRating(
                        context,
                        double.tryParse(review.rating.toString()) ?? 0,
                        size: 14,
                      ),

                      // Thay h(1.5) bằng rh(12)
                      SizedBox(height: context.rh(12)),

                      Text(
                        review.positive,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.sp(14),
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget hiển thị sao tối ưu
  Widget _buildStarRating(
    BuildContext context,
    double rating, {
    double size = 18,
  }) {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData;
        Color iconColor;

        if (index < fullStars) {
          iconData = Icons.star;
          iconColor = Colors.orange;
        } else if (index == fullStars && hasHalfStar) {
          iconData = Icons.star_half;
          iconColor = Colors.orange;
        } else {
          iconData = Icons.star_border;
          iconColor = Colors.grey.shade400;
        }

        return Padding(
          padding: EdgeInsets.only(right: context.rw(2)),
          child: Icon(iconData, color: iconColor, size: context.icon(size)),
        );
      }),
    );
  }
}
