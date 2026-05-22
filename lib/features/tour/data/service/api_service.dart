import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:final_project/app/service/get_access_key_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/tour_destination.dart';

class ApiService {
  // 🔹 URL gốc API của bạn — chỉnh lại đúng địa chỉ backend của bạn
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30)
    ),
  );

  // 🔹 Hàm lấy danh sách tour theo điểm đến
  Future<List<TourDestination>> fetchTourDestinations(Locale locale, String token) async {

    final response = await _dio.get('/tour/destination',
      queryParameters: {
        'locale': locale.languageCode
      },
      options: Options(
        headers: {
          'Access-Token': token
        }
      )
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];

      // Kiểm tra xem có key "data" trong JSON không
      if (data != null) {
        List<dynamic> dataList = data;
        final result = dataList
            .map<TourDestination>((item) => TourDestination.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        print(result.length);
        return result;
      } else {
        throw Exception('Không có dữ liệu "data" trong phản hồi API');
      }
    } else {
      throw Exception('Lỗi khi tải dữ liệu: ${response.statusCode}');
    }
  }
}
