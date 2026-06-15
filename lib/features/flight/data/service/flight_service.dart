import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/flight_item.dart';
import '../models/response/flight_list_response.dart';

class FlightService {
  // 1. Singleton pattern: Đảm bảo chỉ có 1 instance duy nhất
  static final FlightService _instance = FlightService._internal();
  factory FlightService() => _instance;

  static int _totalRequestCount = 0; // Đếm tổng request từ khi mở app
  static int _searchSessionCount = 0; // Đếm số lần người dùng nhấn nút "Tìm kiếm"

  late final Dio _dio;

  FlightService._internal() {
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

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        error: true,
        compact: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _totalRequestCount++;
        // Log này giúp soi ID của từng request
        debugPrint('🌐 [API REQ #$_totalRequestCount] [${options.data['airline']}]');
        return handler.next(options);
      },
    ));
  }

  Future<FlightData> fetchFlightInfo({
    required String startAirport,
    required String endAirport,
    required String startDate,
    required String returnDate,
    required int typeAirport,
    required int adults,
    required int children,
    required int infant,
    String provider = 'VNA',
    required String token,
  }) async {
    _searchSessionCount++;
    final currentSession = _searchSessionCount;

    debugPrint('🚀 === BẮT ĐẦU SEARCH SESSION #$currentSession ===');

    final List<String> airlines = ['VIETJET', 'VNA', 'BAMBOO'];

    final List<FlightData?> results = await Future.wait(
      airlines.map(
            (airline) => _searchByAirline(
          airline: airline,
          startAirport: startAirport,
          endAirport: endAirport,
          startDate: startDate,
          returnDate: returnDate,
          typeAirport: typeAirport,
          adults: adults,
          children: children,
          infant: infant,
          provider: provider,
          token: token,
          sessionId: currentSession, // Truyền ID phiên vào để track
        ),
      ),
    );

    debugPrint('🏁 === KẾT THÚC SEARCH SESSION #$currentSession ===');

    List<FlightItem> combinedGo = [];
    List<FlightItem> combinedReturn = [];

    for (var flightData in results) {
      if (flightData != null) {
        if (flightData.lsFlightGo != null) combinedGo.addAll(flightData.lsFlightGo!);
        if (flightData.lsFlightReturn != null) combinedReturn.addAll(flightData.lsFlightReturn!);
      }
    }

    return FlightData.manual(lsFlightGo: combinedGo, lsFlightReturn: combinedReturn);
  }

  Future<FlightData?> _searchByAirline({
    required String airline,
    required String startAirport,
    required String endAirport,
    required String startDate,
    required String returnDate,
    required int typeAirport,
    required int adults,
    required int children,
    required int infant,
    required String provider,
    required String token,
    required int sessionId, // Nhận ID phiên
  }) async {
    try {
      final response = await _dio.post(
        '/flight/search',
        data: {
          "start_airport": startAirport,
          "end_airport": endAirport,
          "start_date": startDate,
          "return_date": returnDate,
          "type_airport": typeAirport,
          "adults": adults,
          "children": children,
          "infant": infant,
          "airline": airline,
          "provider": provider,
        },
        options: Options(headers: {'Access-Token': token}),
      );

      final flightResponse = FlightListResponse.fromJson(response.data);

      if (flightResponse.status == 1 && flightResponse.data != null) {
        return flightResponse.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ Session #$sessionId - Lỗi hãng $airline: ${e.message}");
      return null;
    } catch (e) {
      return null;
    }
  }
}