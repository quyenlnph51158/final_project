import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:final_project/features/train/data/models/train_booking_request/create_booking_request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/response/train_booking_response.dart';

class CreateBookingService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio toàn app
  static final CreateBookingService _instance = CreateBookingService._internal();
  factory CreateBookingService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Kiểm soát spam)
  static int _apiCallCount = 0;

  CreateBookingService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30), // Booking cần thời gian xử lý lâu hơn
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để kiểm soát dữ liệu và phát hiện gọi trùng (Spam)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true, // Bật true để soi lỗi validation từ Server (422)
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<TrainBookingResponse?> createTrainBooking(CreateBookingRequest request) async {
    _apiCallCount++;
    debugPrint('🚂 [TRAIN BOOKING API] Gọi lần thứ: $_apiCallCount');

    final token = await TokenService.getToken();

    // Nếu không có token, chặn ngay lập tức để tiết kiệm request
    if (token == null) {
      debugPrint('❌ [TRAIN BOOKING]: Token null. Vui lòng đăng nhập.');
      return null;
    }

    try {
      final response = await _dio.post(
        '/train/create-booking',
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio tự động parse JSON thành Map
      if (response.data != null) {
        // Kiểm tra status từ phía Server (Giả sử 1 là thành công)
        if (response.data['status'] == 1 || response.statusCode == 200 || response.statusCode == 201) {
          return TrainBookingResponse.fromJson(response.data);
        } else {
          debugPrint('⚠️ Server trả về lỗi logic: ${response.data['msg']}');
        }
      }
      return null;

    } on DioException catch (e) {
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [TRAIN BOOKING ERROR]: $errorMsg');

      // Nếu bạn muốn hiển thị lỗi cụ thể cho người dùng, có thể ném exception
      // throw Exception(errorMsg);
      return null;
    } catch (e) {
      debugPrint('❌ [TRAIN BOOKING LOGIC ERROR]: $e');
      return null;
    }
  }

  // Hàm helper phân loại lỗi để bạn dễ debug
  String _handleDioError(DioException e) {
    if (e.response != null) {
      // Lấy thông báo lỗi chi tiết từ Server (ví dụ: "Chỗ ngồi đã được đặt bởi người khác")
      final String? serverMsg = e.response?.data?['msg'] ?? e.response?.data?['message'];
      if (serverMsg != null) return serverMsg;

      final code = e.response?.statusCode;
      if (code == 401) return "Phiên đăng nhập hết hạn";
      if (code == 422) return "Thông tin đặt vé không hợp lệ (422)";
      if (code == 500) return "Lỗi hệ thống máy chủ (500)";
      return "Lỗi máy chủ: $code";
    }

    if (e.type == DioExceptionType.connectionTimeout) return "Kết nối quá hạn (Timeout)";
    return "Lỗi kết nối mạng: ${e.message}";
  }
}
