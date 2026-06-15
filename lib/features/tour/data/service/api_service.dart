import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/tour_destination.dart';

class ApiService {
  // 1. Singleton Pattern: Đảm bảo chỉ có 1 instance Dio và bộ Interceptor duy nhất
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  // Biến đếm để theo dõi số lần gọi API thực tế (Kiểm soát spam)
  static int _apiCallCount = 0;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để kiểm soát spam và soi dữ liệu (Chỉ chạy ở chế độ Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // Để false vì danh sách điểm đến có thể rất dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  // 🔹 Hàm lấy danh sách tour theo điểm đến
  Future<List<TourDestination>> fetchTourDestinations(Locale locale, String token) async {
    _apiCallCount++;
    debugPrint('📍 [TOUR DESTINATION API] Gọi lần thứ: $_apiCallCount');

    try {
      final response = await _dio.get(
        '/tour/destination',
        queryParameters: {
          'locale': locale.languageCode, // Đảm bảo backend nhận 'vi' hoặc 'en'
        },
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio mặc định ném lỗi nếu statusCode không phải 2xx
      if (response.data != null) {
        final dynamic rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          final List<TourDestination> result = rawData
              .map((item) => TourDestination.fromJson(Map<String, dynamic>.from(item)))
              .toList();

          debugPrint('✅ Tải thành công ${result.length} điểm đến.');
          return result;
        } else {
          // Trường hợp API trả về status 200 nhưng logic data rỗng hoặc lỗi
          return [];
        }
      }

      return [];

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [TOUR DESTINATION ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [TOUR DESTINATION LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu điểm đến');
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
        return "Lỗi phản hồi: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}