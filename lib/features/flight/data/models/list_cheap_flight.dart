import 'package:flutter/cupertino.dart';
import 'package:final_project/features/flight/data/models/airport_object.dart';

class ListCheapFlight{
  final String from;
  final String to;
  final String classs;
  final String type;
  final String image;
  final double price;
  final String code;
  final String name;
  final String logo;
  final AirportObject originAirportObject;
  final AirportObject destinationAirportObject;
  ListCheapFlight({
    required this.from,
    required this.to,
    required this.classs,
    required this.type,
    required this.image,
    required this.price,
    required this.code,
    required this.name,
    required this.logo,
    required this.originAirportObject,
    required this.destinationAirportObject,
  });
  factory ListCheapFlight.fromJson(Map<String, dynamic> json) {
    final priceString = json['price'].toString();
    final double parsedPrice = double.tryParse(priceString) ?? 0.0;
    return ListCheapFlight(
      from: json['from'] as String,
      to: json['to'] as String,
      classs: json['class'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      price: parsedPrice,
      code: json['code'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      originAirportObject: AirportObject.fromJson(json['originAirportObject'] as Map<String, dynamic>),
      destinationAirportObject: AirportObject.fromJson(json['destinationAirportObject'] as Map<String, dynamic>),
    );
  }
}