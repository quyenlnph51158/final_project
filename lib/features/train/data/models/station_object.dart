class StationObject {
  int? id;
  String? name;
  String? province;
  int? order;
  String? code;
  String? label;

  StationObject({this.id, this.name, this.province, this.order, this.code, this.label});

  factory StationObject.fromJson(Map<String, dynamic> json) {
    return StationObject(
      id: json['id'],
      name: json['name'],
      province: json['province'],
      order: json['order'],
      code: json['code'],
      label: json['label'],
    );
  }
}