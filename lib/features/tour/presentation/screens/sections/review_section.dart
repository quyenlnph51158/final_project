import 'package:final_project/features/tour/presentation/screens/widgets/review_card.dart';
import 'package:final_project/features/tour/presentation/screens/review_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../data/models/tour_detail.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.general_reviews,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${calculateAverageRating(widget.detail.reviews).toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              ),
              const Text(
                ' /5',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllReviewsScreen(
                        reviews: widget.detail.reviews,
                        averageRating:
                        calculateAverageRating(widget.detail.reviews),
                      ),
                    ),
                  );
                },
                child: Text(
                  l10n.tour_detail_read_all_reviews,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
          _buildStarRating(calculateAverageRating(widget.detail.reviews)),
          const SizedBox(height: 4),
          Text(
            '${l10n.tour_detail_based_on} ${widget.detail.reviews.length} ${l10n.tour_detail_reviews_count}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
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
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (review.name?.isNotEmpty ?? false)
                              Text(
                                review.name!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            _buildStarRating(
                              double.tryParse(review.rating.toString()) ?? 0,
                            ),
                            const SizedBox(height: 8),
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
                    icon: Icons.arrow_back_ios,
                    onTap: () => _scrollReviews(-1, screenWidth),
                    left: true,
                  ),
                if (_showRightArrow)
                  _buildArrow(
                    icon: Icons.arrow_forward_ios,
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
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ),
    );
  }

  double calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<double>(
      0,
          (sum, r) => sum + (double.tryParse(r.rating.toString()) ?? 0),
    );
    return total / reviews.length;
  }

  Widget _buildStarRating(double rating) {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.orange, size: 20);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.orange, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.orange, size: 20);
        }
      }),
    );
  }
}
