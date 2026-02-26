import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tour_item.dart';

class TourService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<Map<String, dynamic>> fetchTours({
    int page = 1,
    String? travelTo,
    List<int>? locationIds,
    List<int>? typeTours,
    List<int>? propertyRatings,
    String? sortBy,
  }) async {
    // 1. Chuẩn bị Body cho Request
    final Map<String, dynamic> requestBody = {
      "travel_to": travelTo,
      "location_id": locationIds ?? [],
      "type_tour": typeTours ?? [],
      "propertyRating": propertyRatings ?? [],
      "sortBy": sortBy ?? "ratingHighToLow",
    };

    try {
      // 2. Gọi API (Sử dụng POST vì có body phức tạp)
      // Lưu ý: Nếu API của bạn vẫn dùng GET, hãy báo tôi để chuyển sang Query Params
      final response = await http.post(
        Uri.parse('$baseUrl/tour/list?page=$page'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // 3. Phân tích dữ liệu từ 'data' -> 'data' (tours) và 'data' -> 'pagination'
        final List<dynamic> tourJsonList = jsonResponse['data']?['data'] ?? [];
        final Map<String, dynamic> pagination = jsonResponse['data']?['pagination'] ?? {};

        final tours = tourJsonList
            .where((item) => item is Map<String, dynamic>)
            .map((item) => TourItem.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          'tours': tours,
          'pagination': pagination,
        };
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw Exception('Không thể tải danh sách tour');
      }
    } catch (e) {
      print("Error fetching tours: $e");
      rethrow;
    }
  }
}