import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tour_item.dart';

class TourService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<List<TourItem>> fetchTours() async {
    final response = await http.get(Uri.parse('$baseUrl/tour/list'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // ✅ Truy cập data.data đúng cấu trúc
      final List<dynamic> tourJsonList = jsonResponse['data']?['data']??[];

      // ✅ Parse sang List<TourItem>
      return tourJsonList
          .where((item) => item is Map<String, dynamic>)
          .map((item) => TourItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load tours. Status code: ${response.statusCode}');
    }
  }
}
