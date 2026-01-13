// lib/services/policy_service.dart (Đã sửa lỗi 405)

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/features/policy/data/models/policy_infomation.dart';

class PolicyService {
  final String baseUrl = 'https://www.wonderingvietnam.com/api/v1';

  Future<Policy> fetchPolicy({
    required int postId,
    String locale = 'vi',
  }) async {
    // 1. Dùng Query Parameters thay vì Body
    final Uri uri = Uri.parse('$baseUrl/post/detail').replace(
      queryParameters: {
        "post_id": postId.toString(), // Chuyển int sang String cho query parameter
        "locale": locale,
      },
    );

    // 2. THAY THẾ http.post BẰNG http.get
    final response = await http.get(
      uri,
      headers: <String, String>{
        // Thường không cần 'Content-Type' cho GET, nhưng nếu API yêu cầu thì giữ lại
        'Accept': 'application/json',
      },
      // KHÔNG CÓ body trong yêu cầu GET
    );

    if (response.statusCode == 200) {
      print('✅ API Success: Status Code 200');

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 1 && jsonResponse['data'] != null) {
        final Map<String, dynamic> policyData = jsonResponse['data'];

        print('Policy post ID ${policyData['id']} found.');

        return Policy.fromJson(policyData);

      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to retrieve policy detail from API response.');
      }
    } else {
      // Đảm bảo log ra Status Code mới nếu lỗi vẫn xảy ra
      throw Exception('Failed to load policy. Status code: ${response.statusCode}');
    }
  }
}