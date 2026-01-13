// lib/models/policy_model.dart

class Policy {
  final int id;
  final String category;
  // final String? image;
  final String status;
  final String title;
  // final String description;
  final String content; // Nội dung HTML

  Policy({
    required this.id,
    required this.category,
    // required this.image,
    required this.status,
    required this.title,
    // required this.description,
    required this.content,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    // Giả định JSON đầu vào là object 'data'
    return Policy(
      id: json['id'] as int,
      category: json['category'] as String,
      // image: json['image'] as String?,
      status: json['status'] as String,
      title: json['title'] as String,
      // description: json['description'] as String,
      content: json['content'] as String,
    );
  }
}