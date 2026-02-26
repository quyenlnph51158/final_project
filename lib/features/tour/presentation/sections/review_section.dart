import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/core/utils/calculate_average_star.dart';
import 'package:final_project/features/tour/presentation/screens/review_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../../data/models/tour_detail.dart';
import '../widgets/review_card.dart';

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
  late final ScrollController _reviewScrollController;

  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();

    _reviewScrollController = ScrollController();

    _reviewScrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_reviewScrollController.hasClients) return;

    final max = _reviewScrollController.position.maxScrollExtent;
    final offset = _reviewScrollController.offset;

    setState(() {
      _showLeftArrow = offset > 0;
      _showRightArrow = offset < max;
    });
  }

  void _scrollReviews(double direction, double screenWidth) {
    if (!_reviewScrollController.hasClients) return;

    final scrollDistance = screenWidth * 0.7 * direction;

    _reviewScrollController.animateTo(
      _reviewScrollController.offset + scrollDistance,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _reviewScrollController.removeListener(_handleScroll);
    _reviewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: AppLayoutSpacing.reviewTourDetailSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
                        averageRating:
                        CalculateAverageStar.average(widget.detail.reviews),
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
          SizedBox(
            height: AppSizes.reviewItem,
            child: Stack(
              children: [
                ListView.builder(
                  controller: _reviewScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.detail.reviews.length,
                  itemBuilder: (context, index) {
                    final review = widget.detail.reviews[index];
                    final width = screenWidth * 0.8;

                    return ReviewCard(
                      width: width,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_showLeftArrow)
                  _buildArrow(
                    icon: AppIcons.backReview,
                    onTap: () => _scrollReviews(-1, screenWidth),
                    left: true,
                  ),
                if (_showRightArrow)
                  _buildArrow(
                    icon: AppIcons.forwardReview,
                    onTap: () => _scrollReviews(1, screenWidth),
                    left: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow({
    required IconData icon,
    required VoidCallback onTap,
    required bool left,
  }) {
    return Positioned(
      left: left ? 8 : null,
      right: left ? null : 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: kBackgroundIconControl,
            radius: 18,
            child: Icon(icon, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;

    return Row(
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
