import 'package:intl/intl.dart';

import '../../data/models/airport.dart';

class FlightCriteriaState {
  final Airport departureAirport;
  final Airport destinationAirport;
  final String departureDate;
  final String? returnDate;
  final int adultCount, childCount, infantCount;
  final bool roundTrip;

  const FlightCriteriaState({
    required this.departureAirport, required this.destinationAirport,
    required this.departureDate, this.returnDate,
    this.adultCount = 1, this.childCount = 0, this.infantCount = 0,
    this.roundTrip = true,
  });

  String get departureCode => departureAirport.value ?? '';
  String get destinationCode => destinationAirport.value ?? '';
  int get typeAirport => roundTrip ? 2 : 1;

  factory FlightCriteriaState.initial() => FlightCriteriaState(
    departureAirport: Airport.empty(),
    destinationAirport: Airport.empty(),
    departureDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    returnDate: null,
    adultCount: 1,
    childCount: 0,
    infantCount: 0,
    roundTrip: true,
  );

  FlightCriteriaState copyWith({
    Airport? departureAirport, Airport? destinationAirport,
    String? departureDate, String? returnDate,
    int? adultCount, int? childCount, int? infantCount, bool? roundTrip,
  }) => FlightCriteriaState(
    departureAirport: departureAirport ?? this.departureAirport,
    destinationAirport: destinationAirport ?? this.destinationAirport,
    departureDate: departureDate ?? this.departureDate,
    returnDate: returnDate ?? this.returnDate,
    adultCount: adultCount ?? this.adultCount,
    childCount: childCount ?? this.childCount,
    infantCount: infantCount ?? this.infantCount,
    roundTrip: roundTrip ?? this.roundTrip,
  );
}