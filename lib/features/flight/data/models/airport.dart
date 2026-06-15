class Airport {
  String? value;   // HAN
  String? label;// Hà Nội, Việt Nam
  String? desc;    // Hà Nội
  String? country; // Việt Nam
  String? airline; // Sân bay Nội Bài
  String? code;    // HAN (Trường này có ở CheapFlight, có thể null ở ListAirport)

  Airport({
    this.value,
    this.label,
    this.desc,
    this.country,
    this.airline,
    this.code,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      value: json['value'],
      label: json['label'],
      desc: json['desc'],
      country: json['country'],
      airline: json['airline'],
      code: json['code'], // Nếu không có key 'code', nó sẽ tự động gán null
    );
  }
  factory Airport.empty() => Airport(
    value: "",
    label: "",
    desc: "",
    country: "",
    airline: "",
    code: "",
  );
}