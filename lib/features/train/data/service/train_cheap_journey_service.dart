import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cheap_journey.dart';
import '../models/response/train_response.dart'; // Import model của bạn

class CheapJourneyService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<CheapJourney>> fetchCheapJourneys() async {
    try {
      final token = await TokenService.getToken();
      final response = await _dio.post(
        '/train/cheap-journey',
        queryParameters: {'limit': 5,
          "locale": PlatformDispatcher.instance.locale.languageCode,
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
        final dynamic rawData = trainRes.data['listCheapJourney'];

        // ✅ TRƯỜNG HỢP 1: API trả về List [ {...}, {...} ]
        if (rawData is List) {
          return rawData
              .whereType<Map>().map<CheapJourney>(
                (item) =>
                    CheapJourney.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
        // ✅ TRƯỜNG HỢP 2: API trả về Map { "key": {...} }
        else if (rawData is Map) {
          return rawData.values
              .whereType<Map>().map<CheapJourney>(
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
