import 'package:final_project/features/flight/data/models/inventory.dart';
import 'package:final_project/features/flight/data/models/stop_info.dart';
class FlightInfo {
  final String departureCode;
  final String arrivalCode;
  final String flightCode;
  final String airlineSystemText;
  final String flightAirlineText;
  final String flightType;
  final int totalDuration; // Duration in minutes
  final String departureDate; // DateTime string
  final String arrivalDate; // DateTime string
  final int stopNo;
  final String currency;
  final List<Inventory> inventories;
  final List<StopInfo> stopInfos;
  final String logo;

  FlightInfo({
    required this.departureCode,
    required this.arrivalCode,
    required this.flightCode,
    required this.airlineSystemText,
    required this.flightAirlineText,
    required this.flightType,
    required this.totalDuration,
    required this.departureDate,
    required this.arrivalDate,
    required this.stopNo,
    required this.currency,
    required this.inventories,
    required this.stopInfos,
    required this.logo,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      departureCode: json['DepartureCode']?.toString() ?? '',
      arrivalCode: json['ArrivalCode']?.toString() ?? '',
      flightCode: json['FlightCode']?.toString() ?? '',
      airlineSystemText: json['AirlineSystemText']?.toString() ?? '',
      flightAirlineText: json['FlightAirlineText']?.toString() ?? '',
      flightType: json['FlightType']?.toString() ?? '',
      totalDuration: json['TotalDuration'] as int? ?? 0,
      departureDate: json['DepartureDate'] as String? ?? '',
      arrivalDate: json['ArrivalDate'] as String? ?? '',
      stopNo: json['StopNo'] as int? ?? 0,
      currency: json['currency'] as String? ?? '',
      inventories: (json['Inventories'] as List<dynamic>?)
          ?.map((i) => Inventory.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      stopInfos: (json['StopInfos'] as List<dynamic>?)
          ?.map((i) => StopInfo.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      logo: json['airlineObject']?['logo'] as String? ?? '',
    );
  }
}