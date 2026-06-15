import 'airport_object.dart';

class StopInfo {
  int? routeNo;
  String? departureCode;
  String? departureTerminal;
  String? arrivalCode;
  String? arrivalTerminal;
  String? airlineSystem;
  String? airlineSystemText;
  String? flightAirline;
  String? flightAirlineText;
  String? operatingAirline;
  DateTime? departureDate;
  DateTime? arrivalDate;
  int? layoverDuration;
  int? duration;
  String? airPlaneModel;
  String? flightCode;
  AirportObject? originAirport;
  AirportObject? destinationAirport;
  AirlineObject? airlineObject;
  String? timeStart;
  String? dateTimeStart;
  String? timeEnd;
  String? dateTimeEnd;

  StopInfo.fromJson(Map<String, dynamic> json) {
    routeNo = json['RouteNo'];
    departureCode = json['DepartureCode'];
    departureTerminal = json['DepartureTerminal'];
    arrivalCode = json['ArrivalCode'];
    arrivalTerminal = json['ArrivalTerminal'];
    airlineSystem = json['AirlineSystem'];
    airlineSystemText = json['AirlineSystemText'];
    flightAirline = json['FlightAirline'];
    flightAirlineText = json['FlightAirlineText'];
    operatingAirline = json['OperatingAirline'];
    departureDate = json['DepartureDate'] != null
        ? DateTime.parse(json['DepartureDate'])
        : null;
    arrivalDate = json['ArrivalDate'] != null
        ? DateTime.parse(json['ArrivalDate'])
        : null;
    layoverDuration = json['LayoverDuration'];
    duration = json['Duration'];
    airPlaneModel = json['AirPlaneModel'];
    flightCode = json['FlightCode'];
    originAirport = (json['originAirportObject'] is Map)
        ? AirportObject.fromJson(json['originAirportObject']) : null;

    destinationAirport = (json['destinationAirportObject'] is Map)
        ? AirportObject.fromJson(json['destinationAirportObject']) : null;

    airlineObject = (json['airlineObject'] is Map)
        ? AirlineObject.fromJson(json['airlineObject']) : null;
    timeStart = json['timeStart'];
    dateTimeStart = json['dateTimeStart'];
    timeEnd = json['timeEnd'];
    dateTimeEnd = json['dateTimeEnd'];
  }
}
