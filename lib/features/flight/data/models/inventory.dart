import 'package:final_project/features/flight/data/models/fare_detail.dart';
class Inventory {
  final List<String> features;
  final String seatClass;
  final String fareType;
  final int available;
  final FareDetail adultFare;
  final int totalPrice;
  final String currency;

  Inventory({
    required this.features,
    required this.seatClass,
    required this.fareType,
    required this.available,
    required this.adultFare,
    required this.totalPrice,
    required this.currency,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      features: (json['Features'] as List<dynamic>?)?.map((i) => i.toString()).toList() ?? [],
      seatClass: json['SeatClass'] as String? ?? '',
      fareType: json['FareType'] as String? ?? '',
      available: json['Available'] as int? ?? 0,
      adultFare: json['AdultFare'] != null
          ? FareDetail.fromJson(json['AdultFare'] as Map<String, dynamic>)
          : FareDetail(fare: 0, charge: 0, price: 0),
      totalPrice: json['TotalPrice'] as int? ?? 0,
      currency: json['Currency'] as String? ?? '',
    );
  }
}