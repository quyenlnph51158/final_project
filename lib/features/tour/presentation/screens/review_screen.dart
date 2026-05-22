import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const Scaffold();

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        // Chuyển sang nền trắng cho đồng bộ Header
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            // icon size scale theo mật độ điểm ảnh
            icon: Icon(Icons.arrow_back_ios_new, size: context.icon(20)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.general_allReviews,
            style: TextStyle(
              fontSize: context.sp(17), // sp() có clamp bảo vệ layout
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D2939),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SUMMARY HEADER
            SummeryHeader(
              reviews: widget.reviews,
              averageRating: widget.averageRating,
            ),

            // 2. RATING FILTERS
            // Thay h(1) bằng rh(12) để khoảng cách ổn định trên máy màn hình dài
            Container(
              padding: EdgeInsets.symmetric(vertical: context.rh(12)),
              decoration: BoxDecoration(
                color: kBackgroundColor, // Nền xám nhẹ cho thanh filter
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: RatingFilters(
                reviews: widget.reviews,
                selectedRating: _selectedRating,
                onChanged: (rating) {
                  setState(() => _selectedRating = rating);
                },
              ),
            ),

            // 3. REVIEWS LIST
            Expanded(
              child: _filteredReviews.isEmpty
                  ? _buildEmptyState(context, l10n)
                  : ListView.builder(
                      // Sử dụng rh để tạo khoảng đệm cuối trang an toàn cho Home bar
                      padding: EdgeInsets.only(bottom: context.rh(40)),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredReviews.length,
                      itemBuilder: (context, index) {
                        final review = _filteredReviews[index];
                        return ReviewItem(review: review);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: context.icon(56), // Scale icon cân đối
            color: Colors.grey.shade300,
          ),
          // Thay h(2) bằng rh(16)
          SizedBox(height: context.rh(16)),
          Text(
            l10n.no_review(_selectedRating),
            style: TextStyle(
              fontSize: context.sp(14),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
