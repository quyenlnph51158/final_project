class StationDetail {
  int? id;
  String? code;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? tel;

  StationDetail({
    this.id,
    this.code,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.tel,
  });

  factory StationDetail.fromJson(Map<String, dynamic> json) {
    return StationDetail(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tel: json['tel'],
    );
  }
}
