import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsService {
  // 1. Singleton Pattern: Đảm bảo chỉ có 1 instance Dio và 1 bộ Interceptor duy nhất
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;

  late final Dio _dio;

  // Biến đếm để kiểm soát số lần gọi thực tế (Debug)
  static int _apiCallCount = 0;

  NewsService._internal() {
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

    // 2. Tích hợp Interceptor tùy chỉnh của bạn (chỉ chạy 1 lần duy nhất)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _apiCallCount++;
          debugPrint("🛫 [DIO #$_apiCallCount] Gửi: ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("🛬 [DIO #$_apiCallCount] Nhận: ${response.statusCode} từ ${response.requestOptions.path}");
          return handler.next(response);
        },
        onError: (e, handler) {
          debugPrint("⚠️ [DIO #$_apiCallCount] Lỗi: ${e.response?.statusCode} - ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// Hàm lấy tin tức thô
  Future<List<dynamic>> fetchNewsRaw(String token) async {
    try {
      final response = await _dio.get(
        '/news',
        options: Options(headers: {'Access-Token': token}),
      );

      // Kiểm tra cấu trúc dữ liệu an toàn (tránh lỗi null)
      if (response.data != null && response.data['data'] != null) {
        // Tùy theo API: response.data['data']['data'] hoặc response.data['data']
        return response.data['data']['data'] ?? [];
      }
      return [];
    } on DioException catch (e) {
      // 3. Sử dụng hàm xử lý lỗi riêng để code sạch hơn
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Lỗi không xác định: $e");
    }
  }

  // Helper xử lý lỗi chi tiết
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối quá hạn (30s)";
      case DioExceptionType.receiveTimeout:
        return "Server phản hồi chậm";
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) return "Phiên đăng nhập hết hạn";
        if (e.response?.statusCode == 500) return "Lỗi hệ thống máy chủ";
        return "Lỗi phản hồi: ${e.response?.statusCode}";
      default:
        return "Lỗi kết nối máy chủ";
    }
  }
}