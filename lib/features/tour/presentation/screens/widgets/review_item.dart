import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/reviews_tourdetail.dart';

class ReviewItem extends StatelessWidget{
  final Reviews review;
  const ReviewItem({
    super.key,
    required this.review
  });
  @override
  Widget build(BuildContext context) {
    int _selectedRating = 0;
    final reviewRating = double.tryParse((review.rating as num).toString()) ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.name ?? 'Khách hàng ẩn danh',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildStarRating(reviewRating, size: 18),
            const SizedBox(height: 8),
            if (review.comment != null && review.comment!.isNotEmpty)
              Text(
                review.comment!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (review.positive != null && review.positive!.isNotEmpty)
              Text(
                review.positive!,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
          ],
        ),
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