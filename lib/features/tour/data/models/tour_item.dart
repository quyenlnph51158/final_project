import 'package:final_project/features/tour/data/models/tour_category_connect.dart';

class TourItem {
  final int id;
  final String name;
  final String description;
  final String code;
  final int reviewsCount;
  final List<TourCategoryConnect> category;
  final String duration;
  final String price;
  final String image;

  TourItem({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.reviewsCount,
    required this.category,
    required this.duration,
    required this.price,
    required this.image,
  });

  factory TourItem.fromJson(Map<String, dynamic> json) {
    return TourItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      reviewsCount: json['reviews_count'] ?? 0,
      category: (json['category'] as List<dynamic>? ?? [])
          .map((categoryJson) => TourCategoryConnect.fromJson(categoryJson)) // ✅ Biến lặp rõ ràng hơn
          .toList(),
      duration: json['duration'] ?? '',
      price: json['price']?.toString() ?? '0',
      image: json['image'] ?? '',
    );
  }
}
