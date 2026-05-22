import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/tour_item.dart';

class TourService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> fetchTours({
    int page = 1,
    String? travelTo,
    List<int>? locationIds,
    List<int>? typeTours,
    List<int>? propertyRatings,
    String? sortBy,
    required Locale locale,
    String? token,
  }) async {
    try {
      // 2. Gọi API (Sử dụng POST vì có body phức tạp)
      // Lưu ý: Nếu API của bạn vẫn dùng GET, hãy báo tôi để chuyển sang Query Params

      final response = await _dio.post(
        '/tour/list',
        data: {
          "page": page,
          "travel_to": travelTo,
          "location_id": locationIds ?? [],
          "type_tour": typeTours ?? [],
          "propertyRating": propertyRatings ?? [],
          "sortBy": sortBy ?? "ratingHighToLow",
          "locale": locale.languageCode,
        },
        options: Options(headers: {'Access-Token': token}),
      );

      if (response.statusCode == 200) {
        // 3. Phân tích dữ liệu từ 'data' -> 'data' (tours) và 'data' -> 'pagination'
        final List<dynamic> tourJsonList = response.data['data']['data'];
        final Map<String, dynamic> pagination =
            response.data['data']['pagination'];

        final tours = tourJsonList
            .where((item) => item is Map<String, dynamic>)
            .map((item) => TourItem.fromJson(item as Map<String, dynamic>))
            .toList();

        return {'tours': tours, 'pagination': pagination};
      } else {
        print(
          "API Error: ${response.statusCode} - ${response.data['message']}",
        );
        throw Exception('Không thể tải danh sách tour');
      }
    } catch (e) {
      print("Error fetching tours: $e");
      rethrow;
    }
  }
}
