import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:final_project/features/train/data/models/train_booking_request/create_booking_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/response/train_booking_response.dart';

class CreateBookingService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    )
  );
  Future<TrainBookingResponse?> createTrainBooking(CreateBookingRequest request) async{
    final token = await TokenService.getToken();
    try{
      final response = await _dio.post('/train/create-booking',
        data: request.toJson(),
        options: Options(
          headers: {
            'Access-Token' : token,
          }
        )
      );
      if(response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final Map<String, dynamic> dataMap = response.data;

          // Chuyển Map thành Model Object
          return TrainBookingResponse.fromJson(dataMap);
        }
      }

      return null;

    }on DioException catch(e){
      if (e.response != null) {
        // In ra toàn bộ nội dung lỗi Server trả về (ví dụ: thiếu trường gì, sai định dạng gì)
        debugPrint('SERVER ERROR (422/400): ${e.response?.data}');
      } else {
        debugPrint('NETWORK ERROR: ${e.message}');
      }
      return null;
    } catch (e) {
      debugPrint('LOGIC ERROR (Có thể do sai tên trường trong Model): $e');
      return null;
    }
  }
}