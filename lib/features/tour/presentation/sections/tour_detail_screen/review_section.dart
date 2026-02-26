import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/core/utils/calculate_average_star.dart';
import 'package:final_project/features/tour/presentation/screens/review_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/tour/app_layout_spacing.dart';
import '../../../data/models/tour_detail.dart';
import '../../widgets/review_card.dart';

// ... các import giữ nguyên

class ReviewSection extends StatefulWidget {
  final TourDetail detail;

  const ReviewSection({
    super.key,
    required this.detail,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  // Đã loại bỏ ScrollController và các hàm liên quan đến Scroll/Arrow

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Lấy tối đa 3 review đầu tiên
    final displayReviews = widget.detail.reviews.take(3).toList();

    return Padding(
      padding: AppLayoutSpacing.reviewTourDetailSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tiêu đề và nút "Xem tất cả"
          Text(
            key: widget.key,
            l10n.general_reviews,
            style: AppStyles.titleReviewSection,
          ),
          AppLayoutSpacing.titleReviewAndContent,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${CalculateAverageStar.average(widget.detail.reviews).toStringAsFixed(1)}',
                style: AppStyles.averageRatingValue,
              ),
              Text(
                ' /5',
                style: AppStyles.averageRatingSuffix,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllReviewsScreen(
                        reviews: widget.detail.reviews,
                        averageRating: CalculateAverageStar.average(widget.detail.reviews),
                      ),
                    ),
                  );
                },
                child: Text(
                  l10n.tour_detail_read_all_reviews,
                  style: AppStyles.textReadAllReviewSection,
                ),
              ),
            ],
          ),
          _buildStarRating(CalculateAverageStar.average(widget.detail.reviews)),
          AppLayoutSpacing.iconStarAndInfoReview,
          Text(
            '${l10n.tour_detail_based_on} ${widget.detail.reviews.length} ${l10n.tour_detail_reviews_count}',
            style: AppStyles.textBasedOn,
          ),

          AppLayoutSpacing.reviewInfoAndReviewItem,

          // Danh sách Review hiển thị theo chiều dọc
          ListView.separated(
            shrinkWrap: true, // Quan trọng: Để ListView nằm trong Column
            physics: const NeverScrollableScrollPhysics(), // Để scroll theo trang chính
            itemCount: displayReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16), // Khoảng cách giữa các card
            itemBuilder: (context, index) {
              final review = displayReviews[index];

              return ReviewCard(
                width: double.infinity, // Chiều rộng full màn hình
                child: Padding(
                  padding: AppLayoutSpacing.contentInReviewCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review.name?.isNotEmpty ?? false)
                        Text(
                          review.name!,
                          style: AppStyles.nameCustomerInCard,
                        ),
                      _buildStarRating(
                        double.tryParse(review.rating.toString()) ?? 0,
                      ),
                      AppLayoutSpacing.starAndComment,
                      Text(
                        review.positive ?? review.comment ?? '',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(height: 1.4),
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

  // Widget _buildStarRating giữ nguyên như cũ...
  Widget _buildStarRating(double rating) {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(AppIcons.star.icon, color: Colors.orange, size: 18); // Giả định AppIcons trả về IconData
        } else if (index == fullStars && hasHalfStar) {
          return Icon(AppIcons.half_star.icon, color: Colors.orange, size: 18);
        } else {
          return Icon(AppIcons.star_border.icon, color: Colors.grey, size: 18);
        }
      }),
    );
  }
}
