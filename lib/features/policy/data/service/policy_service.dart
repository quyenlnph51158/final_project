import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:final_project/features/policy/data/models/policy_infomation.dart';

class PolicyService {
  // 1. Singleton Pattern: Đảm bảo chỉ có 1 instance Dio duy nhất
  static final PolicyService _instance = PolicyService._internal();
  factory PolicyService() => _instance;

  late final Dio _dio;

  // Biến đếm để theo dõi số lần gọi API thực tế (Kiểm soát spam)
  static int _apiCallCount = 0;

  PolicyService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Logger để kiểm soát spam và soi dữ liệu (Chỉ chạy ở chế độ Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // Để false vì nội dung policy (HTML) thường rất dài
          error: true,
          compact: true,
        ),
      );
    }
  }

  Future<Policy> fetchPolicy({
    required int postId,
    String locale = 'vi',
    required String token,
  }) async {
    _apiCallCount++;
    debugPrint('📜 [POLICY API] Gọi lần thứ: $_apiCallCount | PostID: $postId');

    try {
      final response = await _dio.get(
        '/post/detail',
        queryParameters: {
          "post_id": postId.toString(),
          "locale": locale,
        },
        options: Options(
          headers: {
            'Access-Token': token,
          },
        ),
      );

      // Dio mặc định ném lỗi nếu statusCode != 2xx
      if (response.data != null) {
        // Kiểm tra logic status từ phía Backend (thường là 1 = Thành công)
        if (response.data['status'] == 1 && response.data['data'] != null) {
          return Policy.fromJson(response.data['data']);
        } else {
          throw Exception(response.data['message'] ?? 'Lỗi không xác định từ API');
        }
      }

      throw Exception('Dữ liệu phản hồi trống');

    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio tập trung
      String errorMsg = _handleDioError(e);
      debugPrint('❌ [POLICY API ERROR]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [POLICY LOGIC ERROR]: $e');
      throw Exception('Lỗi xử lý dữ liệu chính sách');
    }
  }

  // Helper phân loại lỗi để hiển thị lên UI
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối máy chủ quá hạn (30s)";
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return "Phiên đăng nhập hết hạn";
        if (code == 404) return "Không tìm thấy nội dung bài viết";
        if (code == 405) return "Phương thức GET không được hỗ trợ (Lỗi 405)";
        return "Lỗi máy chủ: $code";
      default:
        return "Lỗi kết nối mạng: ${e.message}";
    }
  }
}