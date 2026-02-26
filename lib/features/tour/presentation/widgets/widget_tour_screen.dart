import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../controller/travel_booking_controller.dart';

class FilterCheckboxTile extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Widget? leading;
  final VoidCallback onTap;

  const FilterCheckboxTile({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // Tăng diện tích bấm giúp trải nghiệm người dùng tốt hơn
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isSelected,
                activeColor: Colors.teal,
                // Bo góc checkbox nếu cần (Material 3)
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (_) => onTap(),
              ),
            ),
            const SizedBox(width: 12),
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Widget tiêu đề cho từng phân đoạn
class FilterSectionTitle extends StatelessWidget {
  final String title;
  const FilterSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Bộ lọc Đánh giá (Rating)
class RatingFilterGroup extends StatelessWidget {
  const RatingFilterGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> ratings = [
      {'stars': 5, 'label': l10n.rating_great},
      {'stars': 4, 'label': l10n.rating_good},
      {'stars': 3, 'label': l10n.rating_fine},
      {'stars': 2, 'label': l10n.rating_bad},
      {'stars': 1, 'label': l10n.rating_terrible},
    ];

    return Consumer<TravelBookingController>(
      builder: (context, controller, _) {
        return Column(
          children: ratings.map((rating) {
            final int starCount = rating['stars'];
            final bool isSelected = controller.state.filter.selectedRatings.contains(starCount);

            return FilterCheckboxTile(
              isSelected: isSelected,
              label: rating['label'],
              onTap: () => controller.toggleRatingFilter(starCount),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 18,
                    color: index < starCount ? Colors.orange[300] : Colors.grey[300],
                  );
                }),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Bộ lọc Loại hình Tour
class TourTypeFilterGroup extends StatelessWidget {
  const TourTypeFilterGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelBookingController>(
      builder: (context, controller, _) {
        final categories = controller.state.tour.categories;
        final selectedTypes = controller.state.filter.selectedTourTypes;

        return Column(
          children: categories.map((type) {
            final isSelected = selectedTypes.contains(type.id);

            return FilterCheckboxTile(
              isSelected: isSelected,
              label: type.name,
              onTap: () => controller.toggleTourTypeFilter(type.id),
            );
          }).toList(),
        );
      },
    );
  }
}