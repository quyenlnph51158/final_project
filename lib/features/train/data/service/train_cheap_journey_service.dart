import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import '../models/cheap_journey.dart';
import '../models/response/train_response.dart';

class CheapJourneyService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và Interceptor toàn app
  static final CheapJourneyService _instance = CheapJourneyService._internal();
  factory CheapJourneyService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Giúp phát hiện Spam/Logic lặp)
  static int _apiCallCount = 0;

  CheapJourneyService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để kiểm soát dữ liệu và phát hiện gọi trùng (chỉ chạy ở Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // Để false vì danh sách journey có thể dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm lấy danh sách hành trình giá rẻ
  Future<List<CheapJourney>> fetchCheapJourneys() async {
    _apiCallCount++;
    debugPrint('🚂 [CHEAP JOURNEY API] Gọi lần thứ: $_apiCallCount');

    try {
      final token = await TokenService.getToken();

      final response = await _dio.post(
        '/train/cheap-journey',
        queryParameters: {
          'limit': 5,
          "locale": PlatformDispatcher.instance.locale.languageCode,
        },
        options: Options(headers: {'Access-Token': token}),
      );

      // 3. Parse qua model TrainResponse chung
      final trainRes = TrainResponse(
        status: response.data['status'] ?? 0,
        msg: response.data['msg'] ?? '',
        data: response.data['data'],
      );

      if (trainRes.status == 1 && trainRes.data != null) {
        final dynamic rawData = trainRes.data['listCheapJourney'];

        // Logic xử lý linh hoạt cho cả List và Map (Tránh lỗi từ Backend)
        List<dynamic> items = [];
        if (rawData is List) {
          items = rawData;
        } else if (rawData is Map) {
          items = rawData.values.toList();
        }

        final List<CheapJourney> result = items
            .whereType<Map>()
            .map((item) => CheapJourney.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        debugPrint('✅ Tải thành công ${result.length} hành trình giá rẻ.');
        return result;
      } else {
        throw Exception(trainRes.msg ?? 'Lỗi không xác định từ API');
      }
    } on DioException catch (e) {
      // 4. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [CHEAP JOURNEY ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [CHEAP JOURNEY LOGIC ERROR]: $e');
      throw Exception("Lỗi xử lý dữ liệu: $e");
    }
  }

  // Helper phân loại lỗi để hiển thị lên UI
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối máy chủ quá hạn (15s)";
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return "Phiên đăng nhập hết hạn";
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}