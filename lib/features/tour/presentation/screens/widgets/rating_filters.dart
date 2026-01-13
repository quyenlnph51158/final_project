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
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(text),
              selected: isSelected,
              selectedColor: Colors.blue, // Thay bằng kPrimaryColor của bạn
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
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