import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _baseUrl =
      'https://www.wonderingvietnam.com/api/v1/news'; // 🔁 đổi đúng endpoint

  Future<List<dynamic>> fetchNewsRaw() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['data']['data'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
