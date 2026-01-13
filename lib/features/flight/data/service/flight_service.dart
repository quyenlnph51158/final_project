// flight_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight_info.dart';
// import 'flight_model.dart'; // Đảm bảo bạn import file chứa class FlightInfo

class FlightService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<List<FlightInfo>> fetchFLightInfo({
      required String startAirport,
      required String endAirport,
      required String startDate,
      required String returnDate,
      required int typeAirport,
      required int adults,
      required int children,
      required int infant,
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
      "provider": provider,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/flight/search'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('✅ API Success: Status Code 200');

      // Ghi log toàn bộ body (Chỉ khi debug, không nên dùng trong production)
      print('API Response Body: ${response.body}');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // ✅ Truy cập data.data đúng cấu trúc
      final List<dynamic> tourJsonList = jsonResponse['data']?['listAirport']?['go']??[];
      print('Số lượng chuyến bay được tìm thấy: ${tourJsonList.length}');
      // ✅ Parse sang List<TourItem>
      return tourJsonList
          .where((item) => item is Map<String, dynamic>)
          .map((item) => FlightInfo.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load tours. Status code: ${response.statusCode}');
    }
  }
}