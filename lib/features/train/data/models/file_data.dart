class FileData {
  final int? id;
  final String? name;
  final String? mimeType;
  final String? path;
  final String? extension;
  final int? size;

  FileData({this.id, this.name, this.mimeType, this.path, this.extension, this.size});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      name: json['name'],
      mimeType: json['mime_type'],
      path: json['path'],
      extension: json['extension'],
      size: json['size'],
    );
  }
}