import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/airport.dart';
import '../models/response/airport_response.dart';

class ListAirportService {
  // 1. Singleton Pattern: Đảm bảo chỉ có 1 instance service và 1 instance Dio
  static final ListAirportService _instance = ListAirportService._internal();
  factory ListAirportService() => _instance;

  late final Dio _dio;

  // Biến static để đếm số lần gọi API thực tế
  static int _apiCallCount = 0;

  ListAirportService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Log Interceptor để kiểm soát spam và debug dữ liệu
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false, // Để false vì danh sách sân bay rất dài, log sẽ bị rối
        error: true,
        compact: true,
      ));
    }
  }

  Future<List<Airport>> fetchListAirport(String token) async {
    _apiCallCount++;
    debugPrint('🌐 [AIRPORT API] Gọi lần thứ: $_apiCallCount');

    try {
      final response = await _dio.post(
        '/flight/list-airport',
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio tự động kiểm tra statusCode 2xx, nếu ngoài khoảng đó sẽ ném DioException
      if (response.data != null) {
        final airportResponse = AirportResponse.fromJson(response.data);

        if (airportResponse.status == 1 && airportResponse.data != null) {
          return airportResponse.data!.listAirports;
        }
      }

      return [];
    } on DioException catch (e) {
      // Xử lý lỗi tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [AIRPORT API ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [AIRPORT LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu sân bay');
    }
  }

  // Hàm helper phân loại lỗi để hiển thị lên UI
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "Hết hạn kết nối mạng";
    if (e.response?.statusCode == 401) return "Phiên đăng nhập hết hạn";
    if (e.response?.statusCode == 500) return "Lỗi hệ thống máy chủ";
    return "Không thể tải danh sách sân bay: ${e.message}";
  }
}