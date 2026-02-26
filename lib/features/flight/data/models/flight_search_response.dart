import 'flight_info.dart';

class FlightSearchResponse {
  final List<FlightInfo> outbound;
  final List<FlightInfo> returnFlights;

  FlightSearchResponse({
    required this.outbound,
    required this.returnFlights,
  });

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) {
    return FlightSearchResponse(
      outbound: (json['go'] as List<dynamic>)
          .map((e) => FlightInfo.fromJson(e))
          .toList(),
      returnFlights: (json['return'] as List<dynamic>)
          .map((e) => FlightInfo.fromJson(e))
          .toList(),
    );
  }
}
