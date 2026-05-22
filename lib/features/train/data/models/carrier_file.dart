class CarrierFile {
  int? id;
  String? name;
  String? path;
  String? extension;
  int? size;

  CarrierFile({this.id, this.name, this.path, this.extension, this.size});

  factory CarrierFile.fromJson(Map<String, dynamic> json) {
    return CarrierFile(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      extension: json['extension'],
      size: json['size'],
    );
  }
}