import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:final_project/features/tour/data/models/tour_detail.dart';

class TourdetailService {
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

  Future<TourDetail> fetchTourDetail({
    required String q,
    required Locale locale,
    String? token,
  }) async {
    final response = await _dio.get(
      '/tour/detail',
      queryParameters: {
        'q': q,
        'locale': locale.languageCode,
      },
      options: Options(headers: {'Access-Token': token}),
    );

    if (response.statusCode == 200) {
      debugPrint('✅ API Success: Status Code 200');

      // ✅ SỬA LỖI: Khai báo là nullable (Map<String, dynamic>?)
      // và đổi tên biến thành tourDetailJson vì nó là đối tượng đơn.
      final Map<String, dynamic>? tourDetailJson = response.data['data'];

      if (tourDetailJson != null) {
        // Trả về đối tượng sau khi đã kiểm tra null
        return TourDetail.fromJson(tourDetailJson);
      } else {
        // Ném lỗi nếu trường 'data' bị thiếu
        throw Exception(
          'Failed to load tour details: Missing or null "data" field in response.',
        );
      }
    } else {
      throw Exception(
        'Failed to load tours. Status code: ${response.statusCode}',
      );
    }
  }
}
