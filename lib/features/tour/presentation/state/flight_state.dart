import '../../../flight/data/models/flight_info.dart';
import '../../../flight/data/models/list_airport.dart';

class FlightState {
  final List<ListAirport> airports;
  final List<FlightInfo> outboundFlights;
  final List<FlightInfo> returnFlights;
  final FlightInfo? selectedOutboundFlight;
  final FlightInfo? selectedReturnFlight;
  final bool isViewingReturnFlights;

  const FlightState({
    required this.airports,
    required this.outboundFlights,
    required this.returnFlights,
    required this.selectedOutboundFlight,
    required this.selectedReturnFlight,
    required this.isViewingReturnFlights,
  });

  factory FlightState.initial() {
    return const FlightState(
      airports: [],
      outboundFlights: [],
      returnFlights: [],
      selectedOutboundFlight: null,
      selectedReturnFlight: null,
      isViewingReturnFlights: false,
    );
  }

  FlightState copyWith({
    List<ListAirport>? airports,
    List<FlightInfo>? outboundFlights,
    List<FlightInfo>? returnFlights,
    FlightInfo? selectedOutboundFlight,
    FlightInfo? selectedReturnFlight,
    bool? isViewingReturnFlights,
  }) {
    return FlightState(
      airports: airports ?? this.airports,
      outboundFlights: outboundFlights ?? this.outboundFlights,
      returnFlights: returnFlights ?? this.returnFlights,
      selectedOutboundFlight:
      selectedOutboundFlight ?? this.selectedOutboundFlight,
      selectedReturnFlight:
      selectedReturnFlight ?? this.selectedReturnFlight,
      isViewingReturnFlights:
      isViewingReturnFlights ?? this.isViewingReturnFlights,
    );
  }
}
