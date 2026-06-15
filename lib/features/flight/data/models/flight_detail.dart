import 'package:final_project/features/flight/data/models/stop_info.dart';

import 'airport_object.dart';
import 'flight_inventory.dart';

class FlightDetail {
  String? uniqueId;
  String? departureCode;
  String? arrivalCode;
  String? flightCode;
  DateTime? departureDate;
  DateTime? arrivalDate;
  int? totalDuration;
  int? stopNo;
  String? airlineSystem;
  String? flightAirline;
  String? airlineSystemText;
  String? flightAirlineText;
  String? operatingAirline;
  String? flightType;
  bool? isMergeFlight;
  List<FlightInventory>? inventories;
  dynamic cabins;
  List<StopInfo>? stopInfos;
  int? duration;
  String? timeStart;
  String? dateTimeStart;
  String? timeEnd;
  String? dateTimeEnd;
  AirportObject? originAirport;
  AirportObject? destinationAirport;
  String? airlineCode;
  AirlineObject? airlineObject;
  List<String>? flightNumbers;
  String? currency;

  FlightDetail.fromJson(Map<String, dynamic> json, {String? id}) {
    uniqueId = id;
    departureCode = json['DepartureCode'];
    arrivalCode = json['ArrivalCode'];
    flightCode = json['FlightCode'];
    departureDate = json['DepartureDate'] != null ? DateTime.parse(json['DepartureDate']) : null;
    arrivalDate = json['ArrivalDate'] != null ? DateTime.parse(json['ArrivalDate']) : null;
    totalDuration = json['TotalDuration'];
    stopNo = json['StopNo'];
    airlineSystem = json['AirlineSystem'];
    flightAirline = json['FlightAirline'];
    airlineSystemText = json['AirlineSystemText'];
    flightAirlineText = json['FlightAirlineText'];
    operatingAirline = json['OperatingAirline'];
    flightType = json['FlightType'];
    isMergeFlight = json['IsMergeFlight'];
    if (json['Inventories'] != null && json['Inventories'] is List) {
      inventories = (json['Inventories'] as List).map((v) => FlightInventory.fromJson(v)).toList();
    }
    cabins = json['Cabins'];
    if (json['StopInfos'] != null && json['StopInfos'] is List) {
      stopInfos = (json['StopInfos'] as List).map((v) => StopInfo.fromJson(v)).toList();
    }
    duration = json['duration'];
    timeStart = json['timeStart'];
    dateTimeStart = json['dateTimeStart'];
    timeEnd = json['timeEnd'];
    dateTimeEnd = json['dateTimeEnd'];
    originAirport = (json['originAirportObject'] is Map)
        ? AirportObject.fromJson(json['originAirportObject'])
        : null;

    destinationAirport = (json['destinationAirportObject'] is Map)
        ? AirportObject.fromJson(json['destinationAirportObject'])
        : null;
    airlineCode = json['airlineCode'];
    airlineObject = (json['airlineObject'] is Map)
        ? AirlineObject.fromJson(json['airlineObject'])
        : null;
    flightNumbers = json['flightNumbers'] != null ? List<String>.from(json['flightNumbers']) : null;
    currency = json['currency'];
  }
}