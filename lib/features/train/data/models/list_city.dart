class ListCity {
  final int? id;
  final String? name;
  final String? province;
  final int? order;
  final String? code;
  final String? value;
  final String? label;
  final String? desc;
  final String? country;
  ListCity({
    this.id,
    this.name,
    this.province,
    this.order,
    this.code,
    this.value,
    this.label,
    this.desc,
    this.country,
  });
  factory ListCity.fromJson(Map<String,dynamic> json){
    return ListCity(
        id: json['id'] ,
        name: json['name'],
        province: json['province'],
        order: json['order'],
        code: json['code'],
        value: json['value'],
        label: json['label'],
        desc: json['desc'],
        country: json['country'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'order': order,
      'code': code,
      'value': value,
      'label': label,
      'desc': desc,
      'country': country,
    };
  }
}