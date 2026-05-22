class TrainDevice {
  final int? id;
  final String? code;
  final String? name;
  final String? slug;
  final String? content;
  final String? fileLink;
  final List<String> fileLinks;
  final String? country;

  TrainDevice({
    this.id,
    this.code,
    this.name,
    this.slug,
    this.content,
    this.fileLink,
    this.fileLinks = const [],
    this.country,
  });

  // Hàm chuyển đổi từ JSON sang Object
  factory TrainDevice.fromJson(Map<String, dynamic> json) {
    return TrainDevice(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      slug: json['slug'],
      content: json['content'],
      fileLink: json['file_link'],
      // Ép kiểu mảng file_links từ dynamic sang List<String>
      fileLinks: json['file_links'] != null
          ? List<String>.from(json['file_links'])
          : [],
      country: json['country'],
    );
  }

  // Hàm tiện ích để làm sạch nội dung HTML trong content
  String get cleanContent {
    if (content == null) return "";
    return content!
        .replaceAll(RegExp(r'<[^>]*>|&nbsp;'), '')
        .trim();
  }
}