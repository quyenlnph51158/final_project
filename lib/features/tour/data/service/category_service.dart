import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/tour_category.dart';

class CategoryService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và Interceptor toàn app
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API (Giúp phát hiện Spam)
  static int _apiCallCount = 0;

  CategoryService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để kiểm soát dữ liệu và phát hiện gọi trùng (chỉ chạy ở Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // Để false vì danh mục có thể chứa list dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm lấy danh sách danh mục tour
  Future<List<TourCategory>> fetchTourCategories(
      Locale locale,
      String token,
      ) async {
    _apiCallCount++;
    debugPrint('📂 [CATEGORY API] Gọi lần thứ: $_apiCallCount');

    try {
      final response = await _dio.get(
        '/tour/category',
        queryParameters: {
          'locale': locale.languageCode, // 'vi' hoặc 'en'
        },
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio mặc định ném lỗi nếu statusCode không phải 2xx
      if (response.data != null) {
        // Kiểm tra cấu trúc phân cấp: data -> data
        final dynamic rawData = response.data['data'];

        // Tùy thuộc vào Backend trả về nested data như thế nào
        // Ở đây xử lý theo code cũ của bạn là data['data']['data']
        final List<dynamic>? listData = (rawData is Map) ? rawData['data'] : null;

        if (listData != null) {
          final List<TourCategory> result = listData
              .map((item) => TourCategory.fromJson(Map<String, dynamic>.from(item)))
              .toList();

          debugPrint('✅ Tải thành công ${result.length} danh mục tour.');
          return result;
        }
      }

      return [];

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [CATEGORY API ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [CATEGORY LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu danh mục');
    }
  }

  // Helper phân loại lỗi để hiển thị lên UI
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối máy chủ quá hạn (30s)";
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return "Phiên đăng nhập hết hạn";
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}