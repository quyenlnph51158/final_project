class TourCategory {
  final int id;
  final String name;
  final String slug;
  final String image;

  TourCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory TourCategory.fromJson(Map<String, dynamic> json) {
    return TourCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
    };
  }
}