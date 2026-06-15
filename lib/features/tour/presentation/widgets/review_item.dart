import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
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
      margin: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(8),
      ),
      elevation: context.rw(1.0),
      child: Padding(
        padding: EdgeInsets.all(context.rw(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(16)),
                ),
              ],
            ),
            SizedBox(height: context.rh(4)),
            _buildStarRating(reviewRating),
            SizedBox(height: context.rh(8)),
            if ( review.comment.isNotEmpty)
              Text(
                review.comment,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (review.positive.isNotEmpty)
              Text(
                review.positive,
                style: TextStyle(fontSize: context.sp(14), color: Colors.black87),
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