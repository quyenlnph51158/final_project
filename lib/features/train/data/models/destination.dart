import 'file_data.dart';

class Destination {
  final int? id;
  final int? categoryId;
  final String? title;
  final String? description;
  final String? extensions;
  final String? fileLink;
  final List<String>? fileLinks;
  final FileData? file;

  Destination({
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.extensions,
    this.fileLink,
    this.fileLinks,
    this.file,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      extensions: json['extensions'],
      fileLink: json['file_link'],
      fileLinks: json['file_links'] != null ? List<String>.from(json['file_links']) : [],
      file: json['file'] != null ? FileData.fromJson(json['file']) : null,
    );
  }
}