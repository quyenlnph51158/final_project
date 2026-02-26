
import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../data/models/list_airport.dart';
import '../../data/models/list_cheap_flight.dart';

class FlightState {
  final bool isSearching;
  final bool isInitialized;
  final TravelTab selectedTab;
  final FlightTab selectedFlightTab;
  final bool roundTrip;
  final bool isLoading;
  final bool isSearchingFlight;
  final bool isViewingReturnFlights;

  final List<ListCheapFlight> listCheapFlight;
  final List<ListAirport> listAirport;
  final List<FlightInfo>? outboundFlights;
  final List<FlightInfo>? returnFlights;
  final FlightInfo? selectedOutboundFlight;
  final FlightInfo? selectedReturnFlight;
  final List<FlightInfo>? currentFlightResults;

  final String errorMessage;
  final String flightSearchError;

  final String destination;
  final String tempDestination;
  final String departure;
  final String destinationCode;
  final String departureCode;
  final String seatCode;
  final String email;

  final String selectedDate;
  final String? departureDate;
  final String? returnDate;
  final int typeAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;

  const FlightState({
    required this.isSearching,
    required this.isInitialized,
    required this.selectedTab,
    required this.selectedFlightTab,
    required this.roundTrip,
    required this.isLoading,
    required this.isSearchingFlight,
    required this.isViewingReturnFlights,
    required this.listCheapFlight,
    required this.listAirport,
    required this.outboundFlights,
    required this.returnFlights,
    required this.selectedOutboundFlight,
    required this.selectedReturnFlight,
    required this.currentFlightResults,
    required this.errorMessage,
    required this.flightSearchError,
    required this.destination,
    required this.tempDestination,
    required this.departure,
    required this.destinationCode,
    required this.departureCode,
    required this.seatCode,
    required this.email,
    required this.selectedDate,
    required this.departureDate,
    required this.returnDate,
    required this.typeAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  /// 🔹 State mặc định ban đầu
  factory FlightState.initial() {
    return FlightState(
      isSearching: false,
      isInitialized: false,
      selectedTab: TravelTab.flight,
      selectedFlightTab: FlightTab.flight,
      roundTrip: true,
      isLoading: true,
      isSearchingFlight: false,
      isViewingReturnFlights: false,
      listCheapFlight: [],
      listAirport: [],
      outboundFlights: [],
      returnFlights: [],
      selectedOutboundFlight: null,
      selectedReturnFlight: null,
      currentFlightResults: [],
      errorMessage: '',
      flightSearchError: '',
      destination: '',
      tempDestination: '',
      departure: '',
      destinationCode: '',
      departureCode: '',
      seatCode: '',
      email: '',
      selectedDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      departureDate: null,
      returnDate: null,
      typeAirport: 2,
      adultCount: 1,
      childCount: 0,
      infantCount: 0,
    );
  }

  /// 🔹 copyWith để update state
  FlightState copyWith({
    bool? isSearching,
    bool? isInitialized,
    TravelTab? selectedTab,
    FlightTab? selectedFlightTab,
    bool? roundTrip,
    bool? isLoading,
    bool? isSearchingFlight,
    bool? isViewingReturnFlights,
    List<ListCheapFlight>? listCheapFlight,
    List<ListAirport>? listAirport,
    List<FlightInfo>? outboundFlights,
    List<FlightInfo>? returnFlights,
    FlightInfo? selectedOutboundFlight,
    FlightInfo? selectedReturnFlight,
    List<FlightInfo>? currentFlightResults,
    String? errorMessage,
    String? flightSearchError,
    String? destination,
    String? tempDestination,
    String? departure,
    String? destinationCode,
    String? departureCode,
    String? seatCode,
    String? email,
    String? selectedDate,
    String? departureDate,
    String? returnDate,
    int? typeAirport,
    int? adultCount,
    int? childCount,
    int? infantCount,
  }) {
    return FlightState(
      isSearching: isSearching ?? this.isSearching,
      isInitialized: isInitialized ?? this.isInitialized,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
      roundTrip: roundTrip ?? this.roundTrip,
      isLoading: isLoading ?? this.isLoading,
      isSearchingFlight: isSearchingFlight ?? this.isSearchingFlight,
      isViewingReturnFlights: isViewingReturnFlights ?? this.isViewingReturnFlights,
      listCheapFlight: listCheapFlight ?? this.listCheapFlight,
      listAirport: listAirport ?? this.listAirport,
      outboundFlights: outboundFlights ?? this.outboundFlights,
      returnFlights: returnFlights ?? this.returnFlights,
      selectedOutboundFlight: selectedOutboundFlight ?? this.selectedOutboundFlight,
      selectedReturnFlight: selectedReturnFlight ?? this.selectedReturnFlight,
      currentFlightResults: currentFlightResults ?? this.currentFlightResults,
      errorMessage: errorMessage ?? this.errorMessage,
      flightSearchError: flightSearchError ?? this.flightSearchError,
      destination: destination ?? this.destination,
      tempDestination: tempDestination ?? this.tempDestination,
      departure: departure ?? this.departure,
      destinationCode: destinationCode ?? this.destinationCode,
      departureCode: departureCode ?? this.departureCode,
      seatCode: seatCode ?? this.seatCode,
      email: email ?? this.email,
      selectedDate: selectedDate ?? this.selectedDate,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      typeAirport: typeAirport ?? this.typeAirport,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
    );
  }
}
