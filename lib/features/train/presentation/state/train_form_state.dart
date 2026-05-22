import 'package:intl/intl.dart';

class TrainFormState {
  final bool isRoundTrip;
  final String Departure;
  final String Destination;
  final String DepartureCode;
  final String DestinationCode;
  final String DepartureDate;
  final String ReturnDate;
  final int adultCount;
  final int childCount;
  final int infantCount;

  TrainFormState({
    required this.isRoundTrip,
    required this.Departure,
    required this.Destination,
    required this.DepartureCode,
    required this.DestinationCode,
    required this.DepartureDate,
    required this.ReturnDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  factory TrainFormState.initial() {
    return TrainFormState(
      isRoundTrip: true,
      Departure: '',
      Destination: '',
      DepartureCode: '',
      DestinationCode: '',
      DepartureDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      ReturnDate: '',
      adultCount: 1,
      childCount: 0,
      infantCount: 0,
    );
  }

  TrainFormState copyWith({
      bool? isRoundTrip,
      String? Departure,
      String? Destination,
      String? DepartureCode,
      String? DestinationCode,
      String? DepartureDate,
      String? ReturnDate,
      int? adultCount,
      int? childCount,
      int? infantCount
  }) {
    return TrainFormState(
        isRoundTrip: isRoundTrip ?? this.isRoundTrip,
        Departure: Departure ?? this.Departure,
        Destination: Destination ?? this.Destination,
        DepartureCode: DepartureCode ?? this.DepartureCode,
        DestinationCode: DestinationCode ?? this.DestinationCode,
        DepartureDate: DepartureDate ?? this.DepartureDate,
        ReturnDate: ReturnDate ?? this.ReturnDate,
        adultCount: adultCount ?? this.adultCount,
        childCount: childCount ?? this.childCount,
        infantCount: infantCount ?? this.infantCount
    );
  }

}