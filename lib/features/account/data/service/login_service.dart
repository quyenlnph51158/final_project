import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/service/secure_credential_service.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/response/auth_response.dart';

class LoginService {
  final SecureCredentialService _secureService = SecureCredentialService();

  final Dio _dio = Dio(
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

  /// Hàm nội bộ thực hiện việc gọi API login
  Future<AuthResponse> _internalLogin(String account, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'account': account, 'password': password},
      );

      final data = response.data;
      if (data != null && data['data'] != null) {
        return AuthResponse.fromJson(data['data']);
      }

      throw Exception('Dữ liệu phản hồi không đúng định dạng');
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    }
  }

  /// Hàm xử lý đăng nhập từ UI
  Future<AuthResponse?> login(String account, String password) async {
    try {
      final authResponse = await _internalLogin(account, password);

      // Lưu lại thông tin đăng nhập để dùng cho Silent Login
      await _secureService.saveCredentials(account: account, password: password);

      // Lưu token vào TokenService (Tùy logic bạn muốn xử lý ở Controller hay Service)
      await TokenService.saveToken(authResponse.accessToken, authResponse.user);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Tự động đăng nhập bằng thông tin đã lưu
  Future<bool> silentLogin() async {
    try {
      final creds = await _secureService.getCredentials();
      if (creds == null) return false;

      final authResponse = await _internalLogin(
          creds['account'] ?? '',
          creds['password'] ?? ''
      );

      await TokenService.saveToken(authResponse.accessToken, authResponse.user);
      return true;
    } catch (e) {
      // Nếu lỗi 401 (Sai thông tin/Đổi pass) thì xóa creds cũ
      if (e.toString().contains('401') || e.toString().contains('Sai tài khoản')) {
        await _secureService.clearCredentials();
      }
      return false;
    }
  }

  /// Helper xử lý lỗi từ Dio
  String _handleDioError(DioException e) {
    if (e.response != null) {
      // Nếu server trả về message lỗi cụ thể
      final serverMessage = e.response?.data?['message'];
      if (e.response?.statusCode == 401) {
        return serverMessage ?? 'Sai tài khoản hoặc mật khẩu';
      }
      return serverMessage ?? 'Lỗi máy chủ (${e.response?.statusCode})';
    }

    if (e.type == DioExceptionType.connectionTimeout) return 'Kết nối quá hạn';
    if (e.type == DioExceptionType.connectionError) return 'Không có kết nối mạng';

    return 'Lỗi kết nối: ${e.message}';
  }
}
