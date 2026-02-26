import 'package:intl/intl.dart';

class BookingFormState {
  final String departure;
  final String departureCode;
  final String destination;
  final String arrivalCode;
  final String selectedDate;
  final String? returnDate;
  final String tempDestination;


  final int adultCount;
  final int childCount;
  final int infantCount;
  final bool isRoundTrip;
  final int typeAirport;

  const BookingFormState({
    required this.departure,
    required this.departureCode,
    required this.destination,
    required this.arrivalCode,
    required this.selectedDate,
    required this.returnDate,
    required this.tempDestination,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.isRoundTrip,
    required this.typeAirport,
  });

  factory BookingFormState.initial() {
    return BookingFormState(
      departure: '',
      departureCode: '',
      destination: '',
      arrivalCode: '',
      selectedDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      returnDate: null,
      tempDestination: '',
      adultCount: 1,
      childCount: 0,
      infantCount: 0,
      isRoundTrip: true,
      typeAirport: 2,
    );
  }

  BookingFormState copyWith({
    String? departure,
    String? departureCode,
    String? destination,
    String? arrivalCode,
    String? selectedDate,
    String? returnDate,
    String? tempDestination,
    int? adultCount,
    int? childCount,
    int? infantCount,
    bool? isRoundTrip,
    int? typeAirport,
  }) {
    return BookingFormState(
      departure: departure ?? this.departure,
      departureCode: departureCode ?? this.departureCode,
      destination: destination ?? this.destination,
      arrivalCode: arrivalCode ?? this.arrivalCode,
      selectedDate: selectedDate ?? this.selectedDate,
      returnDate: returnDate ?? this.returnDate,
      tempDestination: tempDestination ?? this.tempDestination,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      typeAirport: typeAirport ?? this.typeAirport,
    );
  }
}
