import 'package:final_project/features/flight/data/models/international_flight_pair.dart';
import '../../data/models/flight_info.dart';
import '../../data/models/inventory.dart';
import '../../data/models/list_airport.dart';
import '../../data/models/list_cheap_flight.dart';

class FlightDataState {
  final List<ListCheapFlight> listCheapFlight;
  final List<ListAirport> listAirport;
  final List<FlightInfo> originalOutboundFlights;
  final List<FlightInfo> originalReturnFlights;
  final List<InternationalFlightPair> originalInternationalFlights;
  final List<FlightInfo> outboundFlights;
  final List<FlightInfo> returnFlights;
  final List<InternationalFlightPair> internationalFlights;
  final FlightInfo? selectedOutboundFlight;
  final FlightInfo? selectedReturnFlight;
  final InternationalFlightPair? selectedInternationalFlight;
  final List<FlightInfo>? currentFlightResults;
  final Inventory? selectedOutboundInventory;
  final Inventory? selectedReturnInventory;
  const FlightDataState({
    required this.listCheapFlight,
    required this.listAirport,
    required this.originalOutboundFlights,
    required this.originalReturnFlights,
    required this.originalInternationalFlights,
    required this.outboundFlights,
    required this.returnFlights,
    required this.internationalFlights,
    required this.selectedOutboundFlight,
    required this.selectedReturnFlight,
    required this.selectedInternationalFlight,
    required this.currentFlightResults,
    this.selectedOutboundInventory, // Add this
    this.selectedReturnInventory,
  });
  factory FlightDataState.initial() {
    return FlightDataState(
      listCheapFlight: [],
      listAirport: [],
      originalOutboundFlights: [],
      originalReturnFlights: [],
      originalInternationalFlights: [],
      outboundFlights: [],
      returnFlights: [],
      internationalFlights: [],
      selectedOutboundFlight: null,
      selectedReturnFlight: null,
      selectedInternationalFlight: null,
      currentFlightResults: [],
      selectedOutboundInventory: null,
      selectedReturnInventory: null,
    );
  }
  FlightDataState copyWith({
    List<ListCheapFlight>? listCheapFlight,
    List<ListAirport>? listAirport,
    List<FlightInfo>? originalOutboundFlights,
    List<FlightInfo>? originalReturnFlights,
    List<InternationalFlightPair>? originalInternationalFlights,
    List<FlightInfo>? outboundFlights,
    List<FlightInfo>? returnFlights,
    List<InternationalFlightPair>? internationalFlights,
    FlightInfo? selectedOutboundFlight,
    FlightInfo? selectedReturnFlight,
    InternationalFlightPair? selectedInternationalFlight,
    List<FlightInfo>? currentFlightResults,
    Inventory? selectedOutboundInventory, // Add this
    Inventory? selectedReturnInventory,
  }){
    return FlightDataState(
      listCheapFlight: listCheapFlight ?? this.listCheapFlight,
      listAirport: listAirport ?? this.listAirport,
      originalOutboundFlights: originalOutboundFlights ?? this.originalOutboundFlights,
      originalReturnFlights: originalReturnFlights ?? this.originalReturnFlights,
      originalInternationalFlights: originalInternationalFlights ?? this.originalInternationalFlights,
      outboundFlights: outboundFlights ?? this.outboundFlights,
      returnFlights: returnFlights ?? this.returnFlights,
      internationalFlights: internationalFlights ?? this.internationalFlights,
      selectedOutboundFlight: selectedOutboundFlight ?? this.selectedOutboundFlight,
      selectedReturnFlight: selectedReturnFlight ?? this.selectedReturnFlight,
      selectedInternationalFlight: selectedInternationalFlight ?? this.selectedInternationalFlight,
      currentFlightResults: currentFlightResults ?? this.currentFlightResults,
      selectedOutboundInventory: selectedOutboundInventory ?? this.selectedOutboundInventory,
      selectedReturnInventory: selectedReturnInventory ?? this.selectedReturnInventory,
    );
  }
}