import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/flight/data/models/cheap_flight.dart';
import '../models/response/cheap_flight_response.dart';

class ListCheapFlightService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và Interceptor
  static final ListCheapFlightService _instance = ListCheapFlightService._internal();
  factory ListCheapFlightService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Kiểm soát spam)
  static int _apiCallCount = 0;

  ListCheapFlightService._internal() {
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

    // 2. Thêm Logger để kiểm soát dữ liệu và phát hiện gọi trùng
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false, // Để false vì list vé rẻ thường rất dài
        error: true,
        compact: true,
      ));
    }
  }

  /// Hàm lấy danh sách vé rẻ
  Future<List<CheapFlight>> fetchListCheapFlight(String token) async {
    _apiCallCount++;
    debugPrint('✈️ [CHEAP FLIGHT API] Gọi lần thứ: $_apiCallCount');

    try {
      final response = await _dio.post(
        '/flight/list-cheap-flight',
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      if (response.data != null) {
        // Parse toàn bộ JSON qua Model Response
        final cheapFlightResponse = CheapFlightResponse.fromJson(response.data);

        // Kiểm tra logic status từ phía server (thường là 1 = success)
        if (cheapFlightResponse.status == 1 && cheapFlightResponse.data != null) {
          return cheapFlightResponse.data!.listFlights;
        }
      }

      return [];
    } on DioException catch (e) {
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [CHEAP FLIGHT ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [CHEAP FLIGHT LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu vé rẻ');
    }
  }

  // Hàm helper phân loại lỗi
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "Kết nối máy chủ quá hạn";
    if (e.response?.statusCode == 401) return "Phiên đăng nhập hết hạn";
    if (e.response?.statusCode == 500) return "Lỗi hệ thống từ máy chủ (500)";
    return "Không thể tải danh sách vé rẻ: ${e.message}";
  }
}