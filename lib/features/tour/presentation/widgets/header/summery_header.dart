import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/tour/app_styles.dart';

class SummeryHeader extends StatelessWidget{
  final List<dynamic> reviews;
  final double averageRating;
  const SummeryHeader({super.key,
    required this.reviews,
    required this.averageRating
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: AppLayoutSpacing.paddingSummaryHeaderTour,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${averageRating.toStringAsFixed(1)}',
                style: AppStyles.averageRatingValue,
              ),
              Text(
                '/5',
                style: AppStyles.averageRatingSuffix,
              ),
              AppLayoutSpacing.averageRatingAndInfo,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating(averageRating,),
                  Text(
                    '${l10n.tour_detail_based_on} ${reviews.length} ${l10n.tour_detail_reviews_count}',
                    style: AppStyles.textBasedOn,
                  ),
                ],
              ),
            ],
          ),
        ],
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