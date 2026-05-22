import 'carrier_file.dart';

class Carrier {
  int? id;
  String? code;
  String? name;
  String? content;
  String? fileLink;
  List<String>? fileLinks;
  List<CarrierFile>? files;

  Carrier({this.id, this.code, this.name, this.content, this.fileLink, this.fileLinks, this.files});

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      content: json['content'],
      fileLink: json['file_link'],
      fileLinks: json['file_links'] != null ? List<String>.from(json['file_links']) : null,
      files: json['files'] != null
          ? (json['files'] as List).map((i) => CarrierFile.fromJson(i)).toList()
          : null,
    );
  }
}