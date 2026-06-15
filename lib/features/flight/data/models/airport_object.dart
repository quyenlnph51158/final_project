class AirportObject {
  String? value;
  String? label;
  String? desc;
  String? country;
  String? airline;

  AirportObject({this.value, this.label, this.desc, this.country, this.airline});

  factory AirportObject.fromJson(Map<String, dynamic> json) {
    return AirportObject(
      value: json['value'],
      label: json['label'],
      desc: json['desc'],
      country: json['country'],
      airline: json['airline'],
    );
  }
}

class AirlineObject {
  String? id;
  String? nameEn;
  String? nameVi;
  String? type;
  String? logo;

  AirlineObject({this.id, this.nameEn, this.nameVi, this.type, this.logo});

  factory AirlineObject.fromJson(Map<String, dynamic> json) {
    return AirlineObject(
      id: json['id'],
      nameEn: json['nameEn'],
      nameVi: json['nameVi'],
      type: json['type'],
      logo: json['logo'],
    );
  }
}