import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static String _baseUrl = dotenv.env['BASE_URL'] ?? ''; // 🔁 đổi đúng endpoint

  Future<List<dynamic>> fetchNewsRaw() async {
    final response = await http.get(Uri.parse('$_baseUrl/news'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['data']['data'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
