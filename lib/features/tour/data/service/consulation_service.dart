import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/request/tour_request.dart';
import '../models/response/tour_api_response_model.dart';

class ConsultationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    )
  );


  Future<ApiResponse> submitTourRequest(TourRequest request) async {
    try {
      final token = await TokenService.getToken();
      final response = await _dio.post('/tour/submit_request',
        queryParameters: request.toJson(),
        options: Options(
          headers: {
            'Access-Token': token
          }
        )

      );


      // Xử lý cả phản hồi 200 (thành công) và 422 (lỗi xác thực)
      if (response.statusCode == 200 || response.statusCode == 422) {
        return ApiResponse.fromJson(response.data);
      } else {
        // Xử lý các lỗi HTTP khác (404, 500,...)
        return ApiResponse(
          status: 0,
          message: 'Lỗi máy chủ (${response.statusCode}): ${response.data['message'] ?? 'Không rõ lỗi'}',
        );
      }
    } catch (e) {
      // DEBUG: In ra ngoại lệ cụ thể đang được bắt
      print('DEBUG CATCH EXCEPTION: $e');
      // Xử lý lỗi kết nối mạng (timeout, mất mạng,...)
      return ApiResponse(status: 0, message: 'Lỗi kết nối mạng: $e');
    }
  }
}