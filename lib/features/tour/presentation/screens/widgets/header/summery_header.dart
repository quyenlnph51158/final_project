import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';

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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviews_summary,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${averageRating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              ),
              const Text(
                ' /5',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating(averageRating, size: 24),
                  Text(
                    '${l10n.tour_detail_based_on} ${reviews.length} ${l10n.tour_detail_reviews_count}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStarRating(double rating, {double size = 20}) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }
}