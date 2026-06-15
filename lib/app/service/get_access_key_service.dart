import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetAccessKeyService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
    ),
  );

  Future<String?> fetchGetAccessToken() async {
    try {
      final response = await _dio.post(
        '/account/get-access-token',
        queryParameters: {
          'timestamp': DateTime.now().toString()
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data']['access_token'];
      }
      return null;
    } catch (e) {
      print("Lỗi lấy Access Token: $e");
      return null;
    }
  }
}
