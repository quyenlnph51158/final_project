class CheapJourney {
  final int? id;
  final int? categoryId;
  final String? title;
  final String? description;
  final String? extensions; // Chứa giá vé hoặc thông tin thêm (vd: "15")
  final String? fileLink; // Link ảnh đại diện chính
  final List<String>? fileLinks; // Danh sách các ảnh chi tiết

  CheapJourney({
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.extensions,
    this.fileLink,
    this.fileLinks,
  });

  factory CheapJourney.fromJson(Map<String, dynamic> json) {
    return CheapJourney(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      extensions: json['extensions'],
      fileLink: json['file_link'],
      // Xử lý an toàn cho danh sách chuỗi
      fileLinks: json['file_links'] != null ? List<String>.from(json['file_links']) : [],
    );
  }
}