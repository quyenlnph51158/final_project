import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:flutter/foundation.dart'; // Sử dụng kDebugMode
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/request/flight_booking_request.dart';
import '../models/response/flight_create_booking_response.dart';

class FlightBookingService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  FlightBookingService() {
    // Chỉ log khi đang trong quá trình phát triển (Debug), tắt khi Release để bảo mật và hiệu năng
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // Thay dynamic bằng FlightBookingResponse? để có gợi ý code (IntelliSense)
  Future<FlightBookingResponse?> createFlightBooking(FlightBookingRequest request) async {
    final token = await TokenService.getToken();

    // Nếu token null, trả về lỗi sớm để tiết kiệm tài nguyên
    if (token == null) {
      debugPrint('FLIGHT SERVICE: Token is null');
      return null;
    }

    try {
      final response = await _dio.post(
        '/flight/create-booking',
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // response.data đã được Dio tự động parse thành Map
      if (response.data != null) {
        return FlightBookingResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      String errorMessage = _handleError(e);
      debugPrint('FLIGHT BOOKING ERROR: $errorMessage');
      // Tùy chọn: Có thể throw errorMessage để Controller bắt được và hiển thị Dialog/Toast
      return null;
    } catch (e) {
      debugPrint('FLIGHT LOGIC ERROR: $e');
      return null;
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "Hết hạn kết nối";

    if (e.response != null) {
      // Ưu tiên lấy thông báo lỗi chi tiết từ Server (ví dụ: "Chỗ ngồi đã bị trùng")
      final String? serverMsg = e.response?.data?['msg'] ?? e.response?.data?['message'];
      if (serverMsg != null) return serverMsg;

      if (e.response?.statusCode == 401) return "Phiên đăng nhập hết hạn";
      if (e.response?.statusCode == 422) return "Dữ liệu không hợp lệ (422)";
    }

    return e.message ?? "Lỗi không xác định";
  }
}