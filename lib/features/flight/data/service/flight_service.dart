// flight_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/flight_info.dart';
import '../models/flight_search_response.dart';

class FlightService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<FlightSearchResponse> fetchFlightInfo({
    required String startAirport,
    required String endAirport,
    required String startDate,
    required String returnDate,
    required int typeAirport, // 1: one-way, 2: round-trip
    required int adults,
    required int children,
    required int infant,
    String airline = 'VIETJET',
    String provider = 'VNA',
  }) async {
    final Map<String, dynamic> body = {
      "start_airport": startAirport,
      "end_airport": endAirport,
      "start_date": startDate,
      "return_date": returnDate,
      "type_airport": typeAirport,
      "adults": adults,
      "children": children,
      "infant": infant,
      "airline": airline,
      "provider": provider,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/flight/search'),
      headers: const {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        '❌ Failed to load flights. Status code: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    /// ===== LOG DEBUG (có thể xoá khi production) =====
    print('✅ API SUCCESS');
    print('👉 Raw response: $jsonResponse');

    final Map<String, dynamic> listAirport =
        jsonResponse['data']?['listAirport'] ?? {};

    /// ===== OUTBOUND (GO) =====
    final List<FlightInfo> outboundFlights =
    (listAirport['go'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => FlightInfo.fromJson(e))
        .toList();

    /// ===== RETURN =====
    final List<FlightInfo> returnFlights =
    (listAirport['return'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => FlightInfo.fromJson(e))
        .toList();

    print('✈️ Outbound flights: ${outboundFlights.length}');
    print('↩️ Return flights: ${returnFlights.length}');

    return FlightSearchResponse(
      outbound: outboundFlights,
      returnFlights: returnFlights,
    );
  }
}
