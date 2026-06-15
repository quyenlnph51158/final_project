import 'package:final_project/features/flight/data/models/flight_detail.dart';

import '../../data/models/airport.dart';
import '../../data/models/cheap_flight.dart';
import '../../data/models/flight_inventory.dart';
import '../../data/models/flight_item.dart';
import '../../data/models/response/flight_create_booking_response.dart';

class FlightDataState {
  final String? payload;
  final List<CheapFlight> listCheapFlight;
  final List<Airport> listAirport;
  final bool resetSummary;

  // Flights
  final List<FlightItem> outboundFlights, returnFlights, internationalFlights;

  // Selections
  final FlightDetail? selectedOutboundFlight,
      selectedReturnFlight;
  final FlightItem? selectedInternationalFlight;
  final FlightInventory? selectedOutboundInventory, selectedReturnInventory;

  final FlightBookingResponse? bookingSummary;

  const FlightDataState({
    this.payload,
    this.listCheapFlight = const [],
    this.listAirport = const [],
    this.outboundFlights = const [],
    this.returnFlights = const [],
    this.internationalFlights = const [],
    this.selectedOutboundFlight,
    this.selectedReturnFlight,
    this.selectedInternationalFlight,
    this.selectedOutboundInventory,
    this.selectedReturnInventory,
    this.bookingSummary,
    required this.resetSummary
  });

  factory FlightDataState.initial() => const FlightDataState(payload: null, bookingSummary: null, resetSummary: false);

  FlightDataState copyWith({
    String? payload,
    List<CheapFlight>? listCheapFlight,
    List<Airport>? listAirport,
    List<FlightItem>? outboundFlights,
    List<FlightItem>? returnFlights,
    List<FlightItem>? internationalFlights,
    FlightDetail? selectedOutboundFlight,
    FlightDetail? selectedReturnFlight,
    FlightItem? selectedInternationalFlight,
    FlightInventory? selectedOutboundInventory,
    FlightInventory? selectedReturnInventory,
    FlightBookingResponse? bookingSummary,
    // Thêm các cờ đánh dấu nếu muốn reset về null
    bool resetOutbound = false,
    bool resetReturn = false,
    bool resetIntl = false,
    bool? resetSummary,
  }) => FlightDataState(
    payload: payload ?? this.payload,
    listCheapFlight: listCheapFlight ?? this.listCheapFlight,
    listAirport: listAirport ?? this.listAirport,
    outboundFlights: outboundFlights ?? this.outboundFlights,
    returnFlights: returnFlights ?? this.returnFlights,
    internationalFlights: internationalFlights ?? this.internationalFlights,
    // Nếu cờ reset = true thì gán null, ngược lại mới xét đến giá trị mới hoặc cũ
    selectedOutboundFlight: resetOutbound ? null : (selectedOutboundFlight ?? this.selectedOutboundFlight),
    selectedOutboundInventory: resetOutbound ? null : (selectedOutboundInventory ?? this.selectedOutboundInventory),

    selectedReturnFlight: resetReturn ? null : (selectedReturnFlight ?? this.selectedReturnFlight),
    selectedReturnInventory: resetReturn ? null : (selectedReturnInventory ?? this.selectedReturnInventory),

    selectedInternationalFlight: resetIntl ? null : (selectedInternationalFlight ?? this.selectedInternationalFlight),
    bookingSummary: bookingSummary ?? this.bookingSummary,
    resetSummary: resetSummary ?? this.resetSummary,
  );
}
