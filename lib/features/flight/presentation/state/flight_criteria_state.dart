import 'package:final_project/features/flight/data/models/airport_object.dart';
import 'package:intl/intl.dart';

class FlightCriteriaState {
  final String destination;
  final String tempDestination;
  final String departure;
  final String destinationCode;
  final String departureCode;
  final AirportObject destinationAirport;
  final AirportObject departureAirport;
  final String seatCode;
  final String email;
  final String departureDate;
  final String? returnDate;
  final int typeAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final bool roundTrip;
  const FlightCriteriaState({
    required this.destination,
    required this.tempDestination,
    required this.departure,
    required this.destinationCode,
    required this.departureCode,
    required this.destinationAirport,
    required this.departureAirport,
    required this.seatCode,
    required this.email,
    required this.departureDate,
    required this.returnDate,
    required this.typeAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.roundTrip
  });
  factory FlightCriteriaState.initial() {
    return FlightCriteriaState(
      destination: '',
      tempDestination: '',
      departure: '',
      destinationCode: '',
      departureCode: '',
      destinationAirport: AirportObject(
          value: "",
          label: "",
          desc: "",
          country: "",
          airline: ""
      ),
      departureAirport: AirportObject(
          value: "",
          label: "",
          desc: "",
          country: "",
          airline: ""
      ),
      seatCode: '',
      email: '',
      departureDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      returnDate: null,
      typeAirport: 2,
      adultCount: 1,
      childCount: 0,
      infantCount: 0,
      roundTrip: true
    );
  }
  FlightCriteriaState copyWith({
    String? destination,
    String? tempDestination,
    String? departure,
    String? destinationCode,
    String? departureCode,
    AirportObject? destinationAirport,
    AirportObject? departureAirport,
    String? seatCode,
    String? email,
    String? departureDate,
    String? returnDate,
    int? typeAirport,
    int? adultCount,
    int? childCount,
    int? infantCount,
    bool? roundTrip,
  }) {
    return FlightCriteriaState(
      destination: destination ?? this.destination,
      tempDestination: tempDestination ?? this.tempDestination,
      departure: departure ?? this.departure,
      destinationCode: destinationCode ?? this.destinationCode,
      departureCode: departureCode ?? this.departureCode,
      seatCode: seatCode ?? this.seatCode,
      destinationAirport: destinationAirport ?? this.destinationAirport,
      departureAirport: departureAirport ?? this.departureAirport,
      email: email ?? this.email,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      typeAirport: typeAirport ?? this.typeAirport,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
      roundTrip: roundTrip ?? this.roundTrip
    );
  }
}