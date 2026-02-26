class PromotionModel {
  final String title;
  final String imageUrl;
  final String discount;
  final PromotionType type;

  const PromotionModel({
    required this.title,
    required this.imageUrl,
    required this.discount,
    required this.type,
  });
}

enum PromotionType {
  cruise,
  resort,
}
