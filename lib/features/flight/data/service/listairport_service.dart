import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/list_airport.dart';

class ListAirportService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<List<ListAirport>> fetchListAirport() async {
    // ⭐ SỬA LỖI: Thay http.post bằng http.get
    final response = await http.post(Uri.parse('$baseUrl/flight/list-airport'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // ⭐ THAY ĐỔI QUAN TRỌNG TẠI ĐÂY ⭐
      // 1. Truy cập vào key "data"
      final Map<String, dynamic>? data = jsonResponse['data'] as Map<String, dynamic>?;

      // 2. Truy cập vào key "listAirport" (Đây là một Map)
      final Map<String, dynamic>? listAirportMap = data?['listAirport'] as Map<String, dynamic>?;

      if (listAirportMap == null) {
        return []; // Trả về list rỗng nếu không có dữ liệu
      }

      // 3. Lấy TẤT CẢ CÁC GIÁ TRỊ (values) từ Map (HAN, HPH, SGN...)
      // và chuyển chúng thành List<Map<String, dynamic>>
      final List<dynamic> listAirportJsonList = listAirportMap.values.toList();

      // 4. Parse sang List<ListAirport>
      return listAirportJsonList
          .where((item) => item is Map<String, dynamic>)
          .map((item) => ListAirport.fromJson(item))
          .toList();
    }
    else {
      throw Exception('Failed to load tours. Status code: ${response.statusCode}');
    }
  }
}