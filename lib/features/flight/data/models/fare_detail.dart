class FareDetail {
  final int fare; // Giá cơ bản
  final int charge; // Thuế/Phí
  final int price; // Tổng giá

  FareDetail({
    required this.fare,
    required this.charge,
    required this.price,
  });

  factory FareDetail.fromJson(Map<String, dynamic> json) {
    return FareDetail(
      fare: json['Fare'] as int,
      charge: json['Charge'] as int,
      price: json['Price'] as int,
    );
  }
}