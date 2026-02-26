import '../../features/tour/data/models/reviews_tourdetail.dart';

class CalculateAverageStar {
  static double average(List<Reviews> reviews) {
    if (reviews.isEmpty) return 0.0;

    final total = reviews.fold<double>(
      0,
          (sum, r) => sum + (r.rating ?? 0).toDouble(),
    );

    return total / reviews.length;
  }
}