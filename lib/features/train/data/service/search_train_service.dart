import 'package:dio/dio.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:final_project/features/train/data/models/response/train_search_response.dart';
import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/response/train_response.dart';

class SearchTrainService {
  // 1. Singleton Pattern: Đảm bảo duy nhất 1 instance Dio toàn app
  static final SearchTrainService _instance = SearchTrainService._internal();
  factory SearchTrainService() => _instance;

  late final Dio _dio;

  // Biến đếm để theo dõi số lần gọi API (Kiểm soát spam từ UI)
  static int _apiCallCount = 0;

  SearchTrainService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 20), // Tăng lên 20s vì search tàu thường chậm
        receiveTimeout: const Duration(seconds: 30),
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
          responseBody: false, // Để false vì danh sách tàu rất dài gây lag console
          error: true,
          compact: true,
        ),
      );
    }
  }

  Future<TrainSearchResponse> fetchSearchTrains({
    required String startStationCode,
    required String endStationCode,
    required String startDate,
    required String endDate,
    required String typeStation,
    required String adultCount,
    required String childCount,
    required String infantCount,
  }) async {
    _apiCallCount++;
    debugPrint('🚂 [TRAIN SEARCH API] Gọi lần thứ: $_apiCallCount');

    final token = await TokenService.getToken();

    try {
      // Lưu ý: Thông thường POST sẽ gửi dữ liệu trong 'data' (Body).
      // Nếu Backend của bạn bắt buộc dùng Query Params trên URL thì giữ nguyên.
      final response = await _dio.post(
        '/train/search',
        data: { // Chuyển sang gửi Body (data) thay vì queryParameters nếu có thể
          'start_station': startStationCode,
          'end_station': endStationCode,
          'start_date': startDate,
          'return_date': endDate,
          'type_trip': typeStation,
          'adults': adultCount,
          'children': childCount,
          'infant': infantCount,
        },
        options: Options(headers: {'Access-Token': token}),
      );

      final trainRes = TrainResponse(
        status: response.data['status'] ?? 0,
        msg: response.data['msg'] ?? '',
        data: response.data['data'],
      );

      if (trainRes.status == 1 && trainRes.data != null) {
        final dynamic rawData = trainRes.data;
        String? payload = rawData['payload'];
        List<TrainModel> departureList = [];
        List<TrainModel> returnList = [];

        // Logic Parse dữ liệu an toàn
        if (rawData is Map) {
          final mapData = Map<String, dynamic>.from(rawData);

          // Trường hợp Khứ hồi (lsTrainGo/lsTrainReturn)
          if (mapData.containsKey('lsTrainGo') || mapData.containsKey('lsTrainReturn')) {
            departureList = _parseTrainList(mapData['lsTrainGo']);
            returnList = _parseTrainList(mapData['lsTrainReturn']);
          }
          // Trường hợp trả về Map các chuyến bay (values)
          else {
            departureList = _parseTrainList(mapData.values.toList());
          }
        } else if (rawData is List) {
          departureList = _parseTrainList(rawData);
        }

        return TrainSearchResponse(
          DepartureListTrain: departureList,
          ReturnListTrain: returnList,
          payloadTrain: payload,
        );
      } else {
        throw trainRes.msg ?? 'Không tìm thấy chuyến tàu phù hợp';
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Lỗi xử lý dữ liệu tàu: $e";
    }
  }

  // Helper function để parse list tránh lặp code
  List<TrainModel> _parseTrainList(dynamic list) {
    if (list == null || list is! List) return [];
    return list
        .map((item) => TrainModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Helper phân loại lỗi chuyên sâu
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "Kết nối máy chủ quá hạn";
    if (e.response?.statusCode == 401) return "Phiên đăng nhập hết hạn";
    if (e.response?.statusCode == 500) return "Lỗi hệ thống từ máy chủ (500)";
    final serverMsg = e.response?.data?['msg'] ?? e.response?.data?['message'];
    return serverMsg ?? "Lỗi mạng: ${e.message}";
  }
}