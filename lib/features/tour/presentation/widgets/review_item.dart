import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_elevation.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/reviews_tourdetail.dart';

class ReviewItem extends StatelessWidget{
  final Reviews review;
  const ReviewItem({
    super.key,
    required this.review
  });
  @override
  Widget build(BuildContext context) {
    final reviewRating = double.tryParse((review.rating as num).toString()) ?? 0.0;

    return Card(
      color: kBackgroundColor,
      margin: AppLayoutSpacing.marginCardItem,
      elevation: AppElevation.reviewItemElevation,
      child: Padding(
        padding: AppLayoutSpacing.paddingCardItem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.name ?? 'Khách hàng ẩn danh',
                  style: AppStyles.customerNameReview,
                ),
              ],
            ),
            AppLayoutSpacing.customerNameAndStarIcon,
            _buildStarRating(reviewRating),
            AppLayoutSpacing.starIconAndComment,
            if (review.comment != null && review.comment!.isNotEmpty)
              Text(
                review.comment!,
                style: AppStyles.commentReviewItem,
              ),
            if (review.positive != null && review.positive!.isNotEmpty)
              Text(
                review.positive!,
                style: AppStyles.positiveReviewItem,
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildStarRating(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return AppIcons.star;
        } else if (index == fullStars && hasHalfStar) {
          return AppIcons.half_star;
        } else {
          return AppIcons.star_border;
        }
      }),
    );
  }
}