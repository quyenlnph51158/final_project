import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/model/response/update_profile_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Import các model cần thiết
import 'package:final_project/features/account/data/model/request/update_profile_request.dart';
import 'package:final_project/features/account/data/model/response/change_password_response.dart';
import 'package:final_project/features/account/data/service/token_service.dart';

class UpdateProfileService {
  // 1. Singleton Pattern
  static final UpdateProfileService _instance = UpdateProfileService._internal();
  factory UpdateProfileService() => _instance;

  late final Dio _dio;

  // Biến theo dõi số lần gọi API (Phát hiện spam nút Lưu)
  static int _apiCallCount = 0;

  UpdateProfileService._internal() {
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

    // 2. Logger (Chỉ chạy ở Debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm xử lý cập nhật thông tin cá nhân
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    _apiCallCount++;
    debugPrint('👤 [UPDATE PROFILE API] Gọi lần thứ: $_apiCallCount');

    try {
      final token = await TokenService.getToken();

      final response = await _dio.post(
        '/user/update-profile', // Hãy kiểm tra lại endpoint chính xác từ API Docs của bạn
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token, // Đồng bộ với chuẩn token của dự án bạn
          },
        ),
      );

      // Parse response (Sử dụng lại model response có chứa UserModel)
      final updateRes = UpdateProfileResponse.fromJson(response.data);

      if (updateRes.status == 1) {
        debugPrint('✅ [UPDATE PROFILE] Thành công: ${updateRes.message}');
      } else {
        debugPrint('⚠️ [UPDATE PROFILE] Thất bại: ${updateRes.message}');
      }

      return updateRes;

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [UPDATE PROFILE DIO ERROR]: $errorMsg');

      return UpdateProfileResponse(
        status: 0,
        message: errorMsg,
        user: null,
      );
    } catch (e) {
      debugPrint('❌ [UPDATE PROFILE LOGIC ERROR]: $e');
      return UpdateProfileResponse(
          status: 0,
          message: "Lỗi xử lý dữ liệu: $e",
          user: null
      );
    }
  }

  // Helper phân loại lỗi (Đồng bộ logic toàn dự án)
  String _handleDioError(DioException e) {
    if (e.response != null) {
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