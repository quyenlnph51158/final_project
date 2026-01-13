import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/features/tour/data/models/tour_detail.dart';

class TourdetailService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<TourDetail> fetchTourDetail({
    required String q,
    String locale = 'vi',
  }) async {
    final Map<String, dynamic> body = {
      "q": q,
      "locale": locale,
    };
    final response = await http.get(
      Uri.parse('$baseUrl/tour/detail?q=${Uri.encodeComponent(q)}&locale=$locale'),
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    );


    if (response.statusCode == 200) {
      print('✅ API Success: Status Code 200');

      // Ghi log toàn bộ body (Chỉ khi debug)
      print('API Response Body: ${response.body}');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // ✅ SỬA LỖI: Khai báo là nullable (Map<String, dynamic>?)
      // và đổi tên biến thành tourDetailJson vì nó là đối tượng đơn.
      final Map<String, dynamic>? tourDetailJson = jsonResponse['data'];

      if(tourDetailJson != null){
        print('Có dữ liệu');

        // Trả về đối tượng sau khi đã kiểm tra null
        return TourDetail.fromJson(tourDetailJson);
      } else {
        print('Dữ liệu rỗng hoặc không tìm thấy trường "data"');
        // Ném lỗi nếu trường 'data' bị thiếu
        throw Exception('Failed to load tour details: Missing or null "data" field in response.');
      }
    } else {
      throw Exception('Failed to load tours. Status code: ${response.statusCode}. Body: ${response.body}');
    }
  }
}