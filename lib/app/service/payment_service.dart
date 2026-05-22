import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';

import '../model/payment_response.dart';

class PaymentService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://www.wonderingvietnam.com/api/v1'),
  );

  // 1. Lấy link thanh toán
  Future<PaymentResponse> makePayment(String bookingId) async {
    final token = await TokenService.getToken();
    try {
      final response = await _dio.post(
        '/payment/make-payment',
        options: Options(
          headers: {
            'Access-Token': token
          }
        ),
        data: {
          "booking_sid": bookingId, // Hoặc các tham số Backend yêu cầu
          "payment_gateway": "onepay"
        },
      );
      return PaymentResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Lỗi tạo link thanh toán: $e");
    }
  }

  // 2. Kiểm tra trạng thái thực sự từ Server
  Future<bool> checkPaymentStatus(String transactionId) async {
    final token = TokenService.getToken();
    try {
      final response = await _dio.get(
        '/payment/check-status',
        queryParameters: {"transaction_sid": transactionId},
        options: Options(
            headers: {
              'Access-Token' : token,
            }
        )
      );
      return response.data['data']['status'] == 'success';
    } catch (e) {
      return false;
    }
  }
}
