import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tour_category.dart';
import 'package:final_project/features/tour/data/models/response/api_category_response.dart';

class CategoryService {
  // Thay thế bằng URL API thực tế của bạn
  final String _baseUrl = "https://www.wonderingvietnam.com/api/v1";

  // Hàm lấy danh sách danh mục tour
  Future<List<TourCategory>> fetchTourCategories() async {
    final url = Uri.parse('$_baseUrl/tour/category'); // Thay đổi endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã body phản hồi từ JSON string sang Map
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Tạo đối tượng ApiResponse từ json
        final apiResponse = ApiResponse.fromJson(jsonResponse);

        // Kiểm tra status nếu cần
        if (apiResponse.status == 1) {
          return apiResponse.data;
        } else {
          // Xử lý lỗi từ API (ví dụ: status != 1)
          throw Exception('Lỗi từ API: ${apiResponse.message}');
        }
      } else {
        // Xử lý lỗi HTTP status code
        throw Exception('Không thể tải danh mục tour. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi kết nối, giải mã JSON, v.v.
      print('Lỗi khi fetch tour categories: $e');
      rethrow; // Ném lại lỗi để UI có thể xử lý
    }
  }
}