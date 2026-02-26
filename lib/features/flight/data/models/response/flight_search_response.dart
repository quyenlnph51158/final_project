import '../flight_info.dart';
import '../international_flight_pair.dart';

class FlightSearchResponse {
  final List<FlightInfo> outboundFlights;
  final List<FlightInfo> returnFlights;
  final List<InternationalFlightPair> internationalPairs; // Danh sách vé kép quốc tế

  FlightSearchResponse({
    this.outboundFlights = const [],
    this.returnFlights = const [],
    this.internationalPairs = const [],
  });
}