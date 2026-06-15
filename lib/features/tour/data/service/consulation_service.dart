import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/request/tour_request.dart';
import '../models/response/tour_api_response_model.dart';

class ConsultationService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và bộ Interceptor toàn app
  static final ConsultationService _instance = ConsultationService._internal();
  factory ConsultationService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API (Giúp phát hiện Spam/Re-build lặp)
  static int _apiCallCount = 0;

  ConsultationService._internal() {
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
          responseBody: true, // Form tư vấn dữ liệu ngắn nên có thể bật để xem lỗi validate
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm gửi yêu cầu tư vấn Tour
  Future<ApiResponse> submitTourRequest(TourRequest request) async {
    _apiCallCount++;
    debugPrint('📝 [CONSULTATION API] Gọi lần thứ: $_apiCallCount');

    try {
      final token = await TokenService.getToken();
      if (token == null) {
        return ApiResponse(status: 0, message: 'Vui lòng đăng nhập để gửi yêu cầu');
      }

      // ⚠️ LƯU Ý: Với phương thức POST, dữ liệu thường được gửi trong 'data' (Request Body)
      // thay vì 'queryParameters' (trên URL). Tôi đã chuyển sang 'data'.
      final response = await _dio.post(
        '/tour/submit_request',
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio mặc định coi status 2xx là thành công.
      // Nếu Server của bạn trả về 422 cho lỗi xác thực, Dio sẽ ném vào 'on DioException'
      if (response.data != null) {
        return ApiResponse.fromJson(response.data);
      }

      return ApiResponse(status: 0, message: 'Dữ liệu phản hồi trống');

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      final errorMsg = _handleDioError(e);
      debugPrint('❌ [CONSULTATION API ERROR]: $errorMsg');

      // Nếu server trả về lỗi 422 nhưng vẫn kèm JSON message
      if (e.response?.data != null) {
        try {
          return ApiResponse.fromJson(e.response!.data);
        } catch (_) {}
      }

      return ApiResponse(status: 0, message: errorMsg);
    } catch (e) {
      debugPrint('❌ [CONSULTATION LOGIC ERROR]: $e');
      return ApiResponse(status: 0, message: 'Lỗi không xác định: $e');
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
        if (code == 422) return "Thông tin nhập vào không hợp lệ";
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng hoặc server đang bảo trì";
    }
  }
}