class SeatClass {
  int? tax;
  num? price;
  String? title;

  SeatClass({this.tax, this.price, this.title});

  factory SeatClass.fromJson(Map<String, dynamic> json) {
    return SeatClass(
      tax: json['tax'],
      price: json['price']?.toDouble(),
      title: json['title'],
    );
  }
}
