class TourCategoryConnect {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int zi_file_id;

  TourCategoryConnect({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.zi_file_id,
  });

  factory TourCategoryConnect.fromJson(Map<String, dynamic> json) {
    return TourCategoryConnect(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      zi_file_id: json['zi_file_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'zi_file_id': zi_file_id,
    };
  }
}