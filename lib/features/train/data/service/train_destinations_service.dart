import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import '../models/destination.dart';
import '../models/response/train_response.dart';

class DestinationService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio và Interceptor toàn app
  static final DestinationService _instance = DestinationService._internal();
  factory DestinationService() => _instance;

  late final Dio _dio;

  // Biến static để theo dõi số lần gọi API thực tế (Giúp phát hiện Spam/Logic lặp)
  static int _apiCallCount = 0;

  DestinationService._internal() {
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
          responseBody: false, // Để false vì danh sách điểm đến thường rất dài gây lag console
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm lấy danh sách điểm đến phổ biến
  Future<List<Destination>> fetchDestinations() async {
    _apiCallCount++;
    debugPrint('🚂 [DESTINATION API] Gọi lần thứ: $_apiCallCount');

    try {
      final token = await TokenService.getToken();

      final response = await _dio.post(
        '/train/list-destinations',
        queryParameters: {
          "locale": PlatformDispatcher.instance.locale.languageCode,
        },
        options: Options(headers: {'Access-Token': token}),
      );

      // 3. Parse qua model TrainResponse chung
      if (response.data != null) {
        final trainRes = TrainResponse(
          status: response.data['status'] ?? 0,
          msg: response.data['msg'] ?? '',
          data: response.data['data'],
        );

        if (trainRes.status == 1 && trainRes.data != null) {
          final dynamic rawData = trainRes.data['listDestinations'];

          // Logic xử lý linh hoạt cho cả List và Map (Tránh lỗi từ Backend)
          List<dynamic> items = [];
          if (rawData is List) {
            items = rawData;
          } else if (rawData is Map) {
            items = rawData.values.toList();
          }

          final List<Destination> result = items
              .whereType<Map>()
              .map((item) => Destination.fromJson(Map<String, dynamic>.from(item)))
              .toList();

          debugPrint('✅ Tải thành công ${result.length} điểm đến.');
          return result;
        } else {
          throw Exception(trainRes.msg ?? 'Lỗi không xác định từ API');
        }
      }

      return [];

    } on DioException catch (e) {
      // 4. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [DESTINATION ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [DESTINATION LOGIC ERROR]: $e');
      throw Exception("Lỗi xử lý dữ liệu điểm đến: $e");
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