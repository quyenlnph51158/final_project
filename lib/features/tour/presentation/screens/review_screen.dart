import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../widgets/header/summery_header.dart';
import '../widgets/rating_filters.dart';
import '../widgets/review_item.dart';

class AllReviewsScreen extends StatefulWidget {
  final List<dynamic> reviews;
  final double averageRating;

  const AllReviewsScreen({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  int _selectedRating = 0;

  List<dynamic> get _filteredReviews {
    if (_selectedRating == 0) {
      return widget.reviews;
    }
    return widget.reviews.where((review) {
      final rating = (review.rating as num).toInt();
      return rating == _selectedRating;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.general_allReviews),
        backgroundColor: kFormBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummeryHeader(
              reviews: widget.reviews, averageRating: widget.averageRating),
          RatingFilters(
            reviews: widget.reviews,
            selectedRating: _selectedRating,
            onChanged: (rating) {
              setState(() {
                _selectedRating = rating; // ✅ GÁN Ở ĐÂY
              });
            },
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _filteredReviews.length,
              itemBuilder: (context, index) {
                final review = _filteredReviews[index];
                return ReviewItem(review: review);
              },
            ),
          ),
        ],
      ),
    );
  }
}