import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';

class RatingFilters extends StatefulWidget {
  final List<dynamic> reviews; // Thay 'dynamic' bằng kiểu dữ liệu Review của bạn
  final int selectedRating;
  final ValueChanged<int> onChanged;
  const RatingFilters({super.key, required this.reviews, required this.selectedRating, required this.onChanged,});

  @override
  State<RatingFilters> createState() => _RatingFiltersState();
}

class _RatingFiltersState extends State<RatingFilters> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const List<int> ratings = [0, 5, 4, 3, 2, 1];

    return Container(
      padding: TourLayoutSpacing.paddingRatingFilter(context),
      height: AppSizes.ratingFilters(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: TourLayoutSpacing.paddingRatingFilterState(context),
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          final rating = ratings[index];
          final isSelected = widget.selectedRating == rating;

          // Tính toán text hiển thị
          String text;
          final count = widget.reviews
              .where((r) => (r.rating as num).toInt() == rating)
              .length;

          if (rating == 0) {
            text = '${l10n.reviews_filter_all} (${widget.reviews.length})';
          } else {
            text = '$rating ${l10n.reviews_filter_star(count)}';
          }

          return Padding(
            padding: TourLayoutSpacing.paddingRatingFilterItem(context),
            child: ChoiceChip(
              label: Text(text),
              selected: isSelected,
              selectedColor: kSelectedColor, // Thay bằng kPrimaryColor của bạn
              backgroundColor: kBackgroundColor,
              labelStyle: TextStyle(
                color: isSelected ? kTextSelectedColor : kTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  widget.onChanged(rating);
                }
              },
            ),
          );
        },
      ),
    );
  }
}