import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/tour/data/models/tour_detail.dart';

class TourdetailService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và bộ Interceptor toàn app
  static final TourdetailService _instance = TourdetailService._internal();
  factory TourdetailService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Giúp phát hiện Spam/Logic lặp)
  static int _apiCallCount = 0;

  TourdetailService._internal() {
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
          responseBody: false, // Để false vì chi tiết tour có thể chứa mã HTML/mô tả rất dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm lấy chi tiết tour theo từ khóa/slug 'q'
  Future<TourDetail> fetchTourDetail({
    required String q,
    required Locale locale,
    String? token,
  }) async {
    _apiCallCount++;
    debugPrint('🔍 [TOUR DETAIL API] Gọi lần thứ: $_apiCallCount | Query: $q');

    try {
      final response = await _dio.get(
        '/tour/detail',
        queryParameters: {
          'q': q,
          'locale': locale.languageCode,
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

        if (rawData != null && rawData is Map<String, dynamic>) {
          debugPrint('✅ Tải chi tiết tour thành công.');
          return TourDetail.fromJson(rawData);
        } else {
          throw Exception('Không tìm thấy dữ liệu chi tiết tour (Data null).');
        }
      }

      throw Exception('Dữ liệu phản hồi từ Server trống');

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      final errorMsg = _handleDioError(e);
      debugPrint('❌ [TOUR DETAIL API ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [TOUR DETAIL LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu chi tiết tour');
    }
  }

  // Helper phân loại lỗi để hiển thị lên UI
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối máy chủ quá hạn (30s)";
      case DioExceptionType.receiveTimeout:
        return "Server phản hồi quá chậm";
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return "Phiên đăng nhập hết hạn";
        if (code == 404) return "Không tìm thấy thông tin tour này";
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}