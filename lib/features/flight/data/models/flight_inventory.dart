import 'package:final_project/features/flight/data/models/price_detail.dart';

class FlightInventory {
  String? seatClass;
  String? fareType;
  String? fareBasisCode;
  int? available;
  PriceDetail? adultFare;
  PriceDetail? childFare;
  PriceDetail? infantFare;
  int? totalFare;
  int? totalCharge;
  int? totalPrice;
  String? currency;

  FlightInventory({
    this.seatClass, this.fareType, this.fareBasisCode, this.available,
    this.adultFare, this.childFare, this.infantFare,
    this.totalFare, this.totalCharge, this.totalPrice, this.currency,
  });

  factory FlightInventory.fromJson(Map<String, dynamic> json) {
    return FlightInventory(
      seatClass: json['SeatClass'],
      fareType: json['FareType'],
      fareBasisCode: json['FareBasisCode'],
      available: json['Available'],
      adultFare: json['AdultFare'] != null ? PriceDetail.fromJson(json['AdultFare']) : null,
      childFare: json['ChildFare'] != null ? PriceDetail.fromJson(json['ChildFare']) : null,
      infantFare: json['InfantFare'] != null ? PriceDetail.fromJson(json['InfantFare']) : null,
      totalFare: json['TotalFare'],
      totalCharge: json['TotalCharge'],
      totalPrice: json['TotalPrice'],
      currency: json['Currency'],
    );
  }
}