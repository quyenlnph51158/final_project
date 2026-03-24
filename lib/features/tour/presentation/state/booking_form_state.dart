import 'package:intl/intl.dart';

class BookingFormState {
  final String departure;
  final String departureCode;
  final String destination;
  final String arrivalCode;
  final String selectedDate;
  final String tempDestination;

  const BookingFormState({
    required this.departure,
    required this.departureCode,
    required this.destination,
    required this.arrivalCode,
    required this.selectedDate,
    required this.tempDestination,
  });

  factory BookingFormState.initial() {
    return BookingFormState(
      departure: '',
      departureCode: '',
      destination: '',
      arrivalCode: '',
      selectedDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      tempDestination: '',
    );
  }

  BookingFormState copyWith({
    String? departure,
    String? departureCode,
    String? destination,
    String? arrivalCode,
    String? selectedDate,
    String? tempDestination,
  }) {
    return BookingFormState(
      departure: departure ?? this.departure,
      departureCode: departureCode ?? this.departureCode,
      destination: destination ?? this.destination,
      arrivalCode: arrivalCode ?? this.arrivalCode,
      selectedDate: selectedDate ?? this.selectedDate,
      tempDestination: tempDestination ?? this.tempDestination,
    );
  }
}
