class TourDestination {
  final String label;
  final String image;

  TourDestination({
    required this.label,
    required this.image,
  });

  factory TourDestination.fromJson(Map<String, dynamic> json) {
    return TourDestination(
      label: json['label'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
