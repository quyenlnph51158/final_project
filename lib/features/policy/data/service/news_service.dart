import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NewsService {
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
  Future<List<dynamic>> fetchNewsRaw(String token) async {
    final response = await _dio.get('/news',
      options: Options(
        headers: {
        'Access-Token': token}
      )
    );

    if (response.statusCode == 200) {

      return response.data['data']['data'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
