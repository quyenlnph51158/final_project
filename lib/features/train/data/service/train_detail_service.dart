import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/cheap_journey.dart';
import '../models/response/train_response.dart';

class TrainDetailService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio toàn app
  static final TrainDetailService _instance = TrainDetailService._internal();
  factory TrainDetailService() => _instance;

  late final Dio _dio;
  final String _apiKey = dotenv.env['API_KEY'] ?? "";
  final String _secretKey = dotenv.env['SECRET_KEY'] ?? "";

  // Biến static để theo dõi số lần gọi API (Kiểm soát spam)
  static int _apiCallCount = 0;

  TrainDetailService._internal() {
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

    // 2. Thêm Logger để kiểm soát spam và soi dữ liệu (Chỉ chạy ở Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // Để false vì danh sách có thể dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Hàm tạo Signature bảo mật
  String _buildSignature(Map<String, dynamic> params) {
    // Sắp xếp key theo bảng chữ cái
    var sortedKeys = params.keys.toList()..sort();

    // Nối chuỗi params
    String queryString = sortedKeys.map((key) => "$key=${params[key]}").join('&');

    // Ghép chuỗi theo quy tắc: ApiKey + SecretKey + QueryString
    String rawString = _apiKey + _secretKey + queryString;

    // Băm SHA-256
    return sha256.convert(utf8.encode(rawString)).toString();
  }

  /// Hàm lấy chi tiết hành trình cho một tàu cụ thể
  Future<List<CheapJourney>> fetchCheapJourneys(int carrierId) async {
    _apiCallCount++;
    debugPrint('🚂 [TRAIN DETAIL API] Gọi lần thứ: $_apiCallCount | CarrierID: $carrierId');

    try {
      final token = await TokenService.getToken();

      // Chuẩn bị tham số để tạo chữ ký
      Map<String, dynamic> params = {"train_id": carrierId};
      String signature = _buildSignature(params);

      final response = await _dio.post(
        '/train/detail',
        queryParameters: {
          'train_id': carrierId,
          'check_sum': signature,
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
          final dynamic rawData = trainRes.data;

          // Xử lý linh hoạt dữ liệu trả về (List hoặc Map)
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

          debugPrint('✅ Tải thành công ${result.length} chi tiết hành trình.');
          return result;
        } else {
          throw Exception(trainRes.msg ?? 'Lỗi không xác định từ API');
        }
      }

      return [];

    } on DioException catch (e) {
      // 4. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [TRAIN DETAIL ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [TRAIN DETAIL LOGIC ERROR]: $e');
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
        if (code == 403) return "Chữ ký (Checksum) không hợp lệ";
        if (code == 500) return "Lỗi hệ thống máy chủ (500)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}