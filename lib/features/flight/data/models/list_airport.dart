class ListAirport{
  final String value;
  final String label;
  final String desc;
  final String country;
  final String airline;
  ListAirport({
    required this.value,
    required this.label,
    required this.desc,
    required this.country,
    required this.airline
  });
  factory ListAirport.fromJson(Map<String, dynamic> json) {
    return ListAirport(
      value: json['value'].toString(),
      label: json['label'].toString(),
      desc: json['desc'].toString(),
      country: json['country'].toString(),
      airline: json['airline'].toString(),
    );
  }
}