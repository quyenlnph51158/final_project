import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/tour_category.dart';

class CategoryService {
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

  // Hàm lấy danh sách danh mục tour
  Future<List<TourCategory>> fetchTourCategories(
    Locale locale,
    String token,
  ) async {

    try {
      final response = await _dio.get(
          '/tour/category',
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
        // Kiểm tra status nếu cần
        if (response.data['data']['data'] != null) {
          List<dynamic> data = response.data['data']['data'];
          return data
              .map(
                (item) =>
                    TourCategory.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        } else {
          // Xử lý lỗi từ API (ví dụ: status != 1)
          throw Exception('Lỗi từ API: ${response.data['message']}');
        }
      } else {
        // Xử lý lỗi HTTP status code
        throw Exception(
          'Không thể tải danh mục tour. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Xử lý lỗi kết nối, giải mã JSON, v.v.
      print('Lỗi khi fetch tour categories: $e');
      rethrow; // Ném lại lỗi để UI có thể xử lý
    }
  }
}
