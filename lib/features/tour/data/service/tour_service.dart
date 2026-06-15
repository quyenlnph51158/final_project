import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/tour_item.dart';

class TourService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và bộ Interceptor toàn app
  static final TourService _instance = TourService._internal();
  factory TourService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Giúp phát hiện Spam/Logic lặp)
  static int _apiCallCount = 0;

  TourService._internal() {
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
          responseBody: false, // Để false vì danh sách tour có thể rất dài gây lag console
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm lấy danh sách tour với phân trang và bộ lọc
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
    _apiCallCount++;
    debugPrint('🏖️ [TOUR LIST API] Gọi lần thứ: $_apiCallCount | Trang: $page');

    try {
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

      // Dio mặc định ném lỗi nếu statusCode không phải 2xx
      if (response.data != null && response.data['data'] != null) {
        final dynamic rawData = response.data['data'];

        // 3. Phân tích dữ liệu từ cấu trúc: data -> data (list) và data -> pagination
        final List<dynamic> tourJsonList = rawData['data'] ?? [];
        final Map<String, dynamic> pagination = rawData['pagination'] ?? {};

        final List<TourItem> tours = tourJsonList
            .whereType<Map<String, dynamic>>() // Lọc bỏ các phần tử không đúng định dạng Map
            .map((item) => TourItem.fromJson(item))
            .toList();

        debugPrint('✅ Tải thành công ${tours.length} tours (Trang $page).');

        return {
          'tours': tours,
          'pagination': pagination,
        };
      }

      throw Exception('Dữ liệu phản hồi từ Server trống');

    } on DioException catch (e) {
      // 4. Xử lý lỗi Dio tập trung
      final errorMsg = _handleDioError(e);
      debugPrint('❌ [TOUR LIST API ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [TOUR LIST LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu danh sách tour');
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
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}