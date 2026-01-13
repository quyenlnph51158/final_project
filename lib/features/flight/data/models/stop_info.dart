import 'package:final_project/features/flight/data/models/airport_object.dart';
class StopInfo {
  final String departureCode;
  final String arrivalCode;
  final String flightCode;
  final String airPlaneModel;
  final AirportObject originAirportObject;
  final AirportObject destinationAirportObject;

  StopInfo({
    required this.departureCode,
    required this.arrivalCode,
    required this.flightCode,
    required this.airPlaneModel,
    required this.originAirportObject,
    required this.destinationAirportObject,
  });

  factory StopInfo.fromJson(Map<String, dynamic> json) {
    return StopInfo(
      departureCode: json['DepartureCode'] as String,
      arrivalCode: json['ArrivalCode'] as String,
      flightCode: json['FlightCode'] as String,
      airPlaneModel: json['AirPlaneModel'] as String,
      originAirportObject: AirportObject.fromJson(
          json['originAirportObject'] as Map<String, dynamic>),
      destinationAirportObject: AirportObject.fromJson(
          json['destinationAirportObject'] as Map<String, dynamic>),
    );
  }
}