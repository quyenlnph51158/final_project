import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/tour_destination.dart';

class ApiService {
  // 🔹 URL gốc API của bạn — chỉnh lại đúng địa chỉ backend của bạn
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // 🔹 Hàm lấy danh sách tour theo điểm đến
  Future<List<TourDestination>> fetchTourDestinations() async {
    final url = Uri.parse('$baseUrl/tour/destination'); // Ví dụ endpoint /api/tours
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Kiểm tra xem có key "data" trong JSON không
      if (jsonData['data'] != null) {
        List<dynamic> dataList = jsonData['data'];
        return dataList
            .map((item) => TourDestination.fromJson(item))
            .toList();
      } else {
        throw Exception('Không có dữ liệu "data" trong phản hồi API');
      }
    } else {
      throw Exception('Lỗi khi tải dữ liệu: ${response.statusCode}');
    }
  }
}
