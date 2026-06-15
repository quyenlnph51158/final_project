class TrainDetail {
  int? id;
  String? code;
  String? name;
  int? capacity;

  TrainDetail({this.id, this.code, this.name, this.capacity});

  factory TrainDetail.fromJson(Map<String, dynamic> json) {
    return TrainDetail(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      capacity: json['capacity'],
    );
  }
}