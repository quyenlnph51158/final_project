import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/model/request/register_request.dart';
import 'package:final_project/features/account/data/model/response/register_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterService {
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

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          "name": request.name,
          "password": request.password,
          "confirm_password": request.confirmPassword,
          "phone": request.phone,
        },
      );

      return RegisterResponse(
        status: response.data['status'],
        msg: response.data['msg'],
      );
    } on DioException catch (e) {
      return RegisterResponse(
        message: e.response?.data['message'] ?? 'Register failed',
      );
    }
  }
}
