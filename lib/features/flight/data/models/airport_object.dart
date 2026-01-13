class AirportObject {
  final String value;
  final String label;
  final String desc;
  final String country;
  final String airline; // Tên sân bay

  AirportObject({
    required this.value,
    required this.label,
    required this.desc,
    required this.country,
    required this.airline,
  });

  factory AirportObject.fromJson(Map<String, dynamic> json) {
    return AirportObject(
      value: json['value'] as String,
      label: json['label'] as String,
      desc: json['desc'] as String,
      country: json['country'] as String,
      airline: json['airline'] as String,
    );
  }
}