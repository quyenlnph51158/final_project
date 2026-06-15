import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/secure_credential_service.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/response/auth_response.dart';

class LoginService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<AuthResponse?> login(String account, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'account': account, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['data'] != null) {
          await SecureCredentialService().saveCredentials(account: account, password: password);
          return AuthResponse.fromJson(response.data['data']);
        }

      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sai tài khoản hoặc mật khẩu');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
  Future<bool> silentLogin() async {
    try {
      final creds = await SecureCredentialService().getCredentials();

      if (creds == null)  return false;

      final response = await _dio.post(
        '/auth/login',
        data: {
          'account': creds['account'],
          'password': creds['password'],
        },
      );

      if (response.data['data'] == null){ return false;}
      final data = AuthResponse.fromJson(response.data['data']);


        await TokenService.saveToken(data.accessToken, data.user);
        return true;

    }on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await SecureCredentialService().clearCredentials();
      }
      return false;
    }catch(_){
      return false;
    }
  }

}
