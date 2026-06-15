import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Đọc cấu hình từ .env
  final String _baseUrl = dotenv.env['TRAIN_URL'] ?? "";
  final String _apiKey = dotenv.env['API_KEY'] ?? "";
  final String _secretKey = dotenv.env['SECRET_KEY'] ?? "";

  /// Hàm tạo Signature khớp 100% với ảnh PHP: ksort -> query -> hash
  String _buildSignature(Map<String, dynamic> params) {
    // 1. Sắp xếp key theo bảng chữ cái (ksort)
    var sortedKeys = params.keys.toList()..sort();

    // 2. Nối chuỗi (http_build_query)
    String queryString = sortedKeys
        .map((key) {
          return "$key=${params[key]}";
        })
        .join('&');

    // 3. Ghép chuỗi theo thứ tự trong ảnh: ApiKey + SecretKey + QueryString
    String rawString = _apiKey + _secretKey + queryString;

    print(sha256.convert(utf8.encode(rawString)).toString());
    // 4. Băm SHA-256 (hash('sha256', $sum))
    return sha256.convert(utf8.encode(rawString)).toString();
  }

  /// Hàm lấy dữ liệu Text từ Server
  Future<List<dynamic>> fetchData(String searchKeyword) async {
    // Các tham số gửi đi (Search)
    Map<String, dynamic> params = {"train_id": 12};

    // Tạo chữ ký
    String signature = _buildSignature(params);

    // Thêm các tham số bảo mật vào bộ params gửi đi
    params['signature'] = signature;
    params['api_key'] = _apiKey;

    // Tạo URL hoàn chỉnh
    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // 1. In toàn bộ chuỗi JSON thô từ Server để xem cấu trúc tổng thể
        print("--- RAW RESPONSE BODY ---");
        print(response.body);

        var jsonResponse = json.decode(response.body);

        // 2. Kiểm tra xem 'data' có tồn tại không và kiểu của nó là gì
        var rawData = jsonResponse['data'];

        print("--- DEBUG DATA ---");
        print("Kiểu dữ liệu của 'data' là: ${rawData.runtimeType}");
        print("Giá trị của 'data': $rawData");

        // Logic xử lý tiếp theo của bạn
        if (rawData is List) {
          return rawData;
        } else if (rawData == null) {
          return [];
        } else {
          // Nếu nó là một Map (Object) đơn lẻ, bạn có thể muốn in các key của nó
          if (rawData is Map) {
            print("Các key trong Map: ${rawData.keys}");
          }
          return [];
        }
      } else {
        throw Exception("Lỗi Server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }
}
