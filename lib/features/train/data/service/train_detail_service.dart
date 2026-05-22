import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cheap_journey.dart';
import '../models/response/train_response.dart'; // Import model của bạn

class TrainDetailService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
    ),
  );
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

  Future<List<CheapJourney>> fetchCheapJourneys(int carrier_id) async {
    try {
      final token = await TokenService.getToken();
      Map<String, dynamic> params = {"train_id": carrier_id};
      final response = await _dio.post(
        '/train/detail',
        queryParameters: {
          'train_id': carrier_id,
          'check_sum': _buildSignature(params),
        },
        options: Options(headers: {'Access-Token': token}),
      );
      print(response.data.runtimeType);
      // 1. Khởi tạo TrainResponse (Đảm bảo data trong Model này là dynamic)
      final trainRes = TrainResponse(
        status: response.data['status'] ?? 0,
        msg: response.data['msg'] ?? '',
        data: response.data['data'],
      );

      if (trainRes.isSuccess && trainRes.data != null) {
        final dynamic rawData = trainRes.data;

        // ✅ TRƯỜNG HỢP 1: API trả về List [ {...}, {...} ]
        if (rawData is List) {
          return rawData
              .map<CheapJourney>(
                (item) =>
                    CheapJourney.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
        // ✅ TRƯỜNG HỢP 2: API trả về Map { "key": {...} }
        else if (rawData is Map) {
          return rawData.values
              .map<CheapJourney>(
                (item) =>
                    CheapJourney.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }

        throw Exception('Định dạng "data" CheapJourneys không hợp lệ');
      } else {
        throw Exception(trainRes.msg ?? 'Lỗi không xác định');
      }
    } on DioException catch (e) {
      throw Exception("Lỗi kết nối: ${e.message}");
    } catch (e) {
      // Bắt lỗi ép kiểu hoặc lỗi từ hàm fromJson
      throw Exception("Lỗi xử lý dữ liệu CheapJourneys: $e");
    }
  }
}
