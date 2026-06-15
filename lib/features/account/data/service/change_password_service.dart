import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/account/data/model/request/change_password_request.dart';
import 'package:final_project/features/account/data/model/response/change_password_response.dart';
import 'package:final_project/features/account/data/service/token_service.dart';

class ChangePasswordService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio toàn ứng dụng
  static final ChangePasswordService _instance = ChangePasswordService._internal();
  factory ChangePasswordService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần thử đổi mật khẩu (Phát hiện spam nút Lưu)
  static int _apiCallCount = 0;

  ChangePasswordService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để debug payload mật khẩu (chỉ chạy ở Debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true, // Quan trọng: Để check password gửi đi có đúng format không
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm xử lý đổi mật khẩu
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    _apiCallCount++;
    debugPrint('🔐 [CHANGE PASSWORD API] Thử lần thứ: $_apiCallCount');

    try {
      final token = await TokenService.getToken();

      final response = await _dio.post(
        '/user/change-password',
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token, // Dùng chuẩn Bearer Authorization
          },
        ),
      );

      // Parse response thành model
      final changePassRes = ChangePasswordResponse.fromJson(response.data);

      if (changePassRes.status == 1) {
        debugPrint('✅ [CHANGE PASSWORD] Thành công: ${changePassRes.message}');
      } else {
        debugPrint('⚠️ [CHANGE PASSWORD] Thất bại từ Server: ${changePassRes.message}');
      }

      return changePassRes;

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung và ghi Log
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [CHANGE PASSWORD DIO ERROR]: $errorMsg');

      return ChangePasswordResponse(
        status: 0,
        message: errorMsg,
        user: null,
      );
    } catch (e) {
      debugPrint('❌ [CHANGE PASSWORD LOGIC ERROR]: $e');
      return ChangePasswordResponse(
          status: 0,
          message: "Lỗi xử lý hệ thống: $e",
          user: null
      );
    }
  }

  // Helper phân loại lỗi (Đồng bộ với CheapJourneyService)
  String _handleDioError(DioException e) {
    if (e.response != null) {
      // Ưu tiên lấy message trả về từ Backend (ví dụ: "Mật khẩu cũ không đúng")
      final serverMessage = e.response?.data['message'];
      if (serverMessage != null) return serverMessage.toString();

      final code = e.response?.statusCode;
      if (code == 401) return "Phiên đăng nhập hết hạn (401)";
      if (code == 403) return "Bạn không có quyền thực hiện hành động này (403)";
      if (code == 500) return "Lỗi máy chủ hệ thống (500)";
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối máy chủ quá hạn (15s)";
      case DioExceptionType.sendTimeout:
        return "Gửi yêu cầu quá hạn";
      case DioExceptionType.connectionError:
        return "Không có kết nối internet";
      default:
        return "Lỗi kết nối: ${e.message}";
    }
  }
}