class PriceDetail {
  int? fare;
  int? charge;
  int? price;
  int? discount;
  List<dynamic>? taxDetails;

  PriceDetail({this.fare, this.charge, this.price, this.discount, this.taxDetails});

  factory PriceDetail.fromJson(Map<String, dynamic> json) {
    return PriceDetail(
      fare: json['Fare'],
      charge: json['Charge'],
      price: json['Price'],
      discount: json['Discount'],
      taxDetails: json['TaxDetails'],
    );
  }
}