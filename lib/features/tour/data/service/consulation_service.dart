import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request/tour_request.dart';
import '../models/response/tour_api_response_model.dart';

class ConsultationService {
  // Thay đổi thành URL cơ sở thực tế của bạn
  final String _baseUrl = 'https://www.wonderingvietnam.com/api';

  // ĐÃ LOẠI BỎ 'apikey' VÀ 'Access-Token'
  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<ApiResponse> submitTourRequest(TourRequest request) async {
    final url = Uri.parse('$_baseUrl/v1/tour/submit_request');
    // DEBUG: In ra URL đầy đủ đang được gọi
    print('DEBUG API URL: $url');
    // DEBUG: In ra body request
    print('DEBUG REQUEST BODY: ${jsonEncode(request.toJson())}');
    try {
      final response = await http.post(
        url,
        headers: _headers, // Headers chỉ còn Accept và Content-Type
        body: jsonEncode(request.toJson()), // Chuyển Model thành JSON string
      );

      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // Xử lý cả phản hồi 200 (thành công) và 422 (lỗi xác thực)
      if (response.statusCode == 200 || response.statusCode == 422) {
        return ApiResponse.fromJson(jsonResponse);
      } else {
        // Xử lý các lỗi HTTP khác (404, 500,...)
        return ApiResponse(
          status: 0,
          message: 'Lỗi máy chủ (${response.statusCode}): ${jsonResponse['message'] ?? 'Không rõ lỗi'}',
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