// lib/services/policy_service.dart (Đã sửa lỗi 405)

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:final_project/features/policy/data/models/policy_infomation.dart';

class PolicyService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
    )
  );

  Future<Policy> fetchPolicy({
    required int postId,
    String locale = 'vi',
    required String token
  }) async {
    final response = await _dio.get('/post/detail',
      queryParameters: {
        "post_id": postId.toString(), // Chuyển int sang String cho query parameter
        "locale": locale,
      },
      options: Options(
        headers: {
          'Access-Token': token
        }
      )
    );


    if (response.statusCode == 200) {

      if (response.data['status'] == 1 && response.data['data'] != null) {
        final Map<String, dynamic> policyData = response.data['data'];

        print('Policy post ID ${policyData['id']} found.');

        return Policy.fromJson(policyData);

      } else {
        throw Exception(response.data['message'] ?? 'Failed to retrieve policy detail from API response.');
      }
    } else {
      // Đảm bảo log ra Status Code mới nếu lỗi vẫn xảy ra
      throw Exception('Failed to load policy. Status code: ${response.statusCode}');
    }
  }
}