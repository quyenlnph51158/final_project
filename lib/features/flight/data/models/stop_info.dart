import 'package:final_project/features/flight/data/models/airport_object.dart';
class StopInfo {
  final String departureCode;
  final String arrivalCode;
  final String flightCode;
  final String airPlaneModel;
  final AirportObject originAirportObject;
  final AirportObject destinationAirportObject;
  final String timeStart;
  final String timeEnd;
  final String dateTimeStart; // Thêm dòng này
  final String dateTimeEnd;
  final int layoverDuration;
  StopInfo({
    required this.departureCode,
    required this.arrivalCode,
    required this.flightCode,
    required this.airPlaneModel,
    required this.originAirportObject,
    required this.destinationAirportObject,
    required this.timeStart,
    required this.timeEnd,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.layoverDuration,
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
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      dateTimeStart: json['dateTimeStart'] ?? "",
      dateTimeEnd: json['dateTimeEnd'] ?? "",
      layoverDuration: json['LayoverDuration'] ?? 0,
    );
  }
}