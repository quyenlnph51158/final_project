import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project/features/flight/data/models/response/flight_search_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/flight_info.dart';
import '../models/international_flight_pair.dart';

class FlightService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      headers:{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
    )
  );

  Future<FlightSearchResponse> fetchFlightInfo({
    required String startAirport,
    required String endAirport,
    required String startDate,
    required String returnDate,
    required int typeAirport,
    required int adults,
    required int children,
    required int infant,
    String provider = 'VNA',
    required String token
  }) async {
    final List<String> airlines = ['VIETJET', 'VNA', 'BAMBOO'];

    // Cập nhật: Gọi API song song với timeout riêng cho từng hãng
    final results = await Future.wait(
      airlines.map(
        (airline) =>
            _searchByAirline(
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
              token: token
            ).timeout(
              const Duration(seconds: 45),
              // Tăng lên 45s cho các chặng quốc tế phức tạp
              onTimeout: () {
                debugPrint("⚠️ Timeout hãng $airline - Bỏ qua kết quả hãng này");
                return FlightSearchResponse(); // Trả về object rỗng nếu quá thời gian
              },
            ),
      ),
    );

    List<FlightInfo> allOutbound = [];
    List<FlightInfo> allReturn = [];
    List<InternationalFlightPair> allInternationalPair = [];

    // Gộp kết quả an toàn
    for (var res in results) {
      allOutbound.addAll(res.outboundFlights);
      allReturn.addAll(res.returnFlights);
      allInternationalPair.addAll(res.internationalPairs);
    }

    return FlightSearchResponse(
      outboundFlights: allOutbound,
      returnFlights: allReturn,
      internationalPairs: allInternationalPair,
    );
  }

  Future<FlightSearchResponse> _searchByAirline({
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
  }) async {
    try {
      final response = await _dio.post('/flight/search',
        queryParameters: {
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
        options: Options(
          headers: {
            'Access-Token': token
          }
        )
      );


      if (response.statusCode != 200) {
        return FlightSearchResponse();
      }

      final data = response.data['data'];

      // Kiểm tra dữ liệu thô: Nếu data là mảng rỗng [] (như Vietjet hay trả về khi lỗi) thì bỏ qua
      if (data == null || data is List || data['listAirport'] == null) {
        return FlightSearchResponse();
      }

      final Map<String, dynamic> listAirport = data['listAirport'];
      List<FlightInfo> outboundList = [];
      List<FlightInfo> returnList = [];
      List<InternationalFlightPair> internationalPairs = [];

      // XỬ LÝ MẢNG 'GO'
      if (listAirport['go'] is List) {
        for (var item in listAirport['go']) {
          if (item is! Map<String, dynamic>) continue;

          // KIỂM TRA VÉ CẶP QUỐC TẾ
          if (item.containsKey('go') && item.containsKey('return')) {
            internationalPairs.add(InternationalFlightPair.fromJson(item));
          }
          // VÉ ĐƠN NỘI ĐỊA
          else {
            outboundList.add(FlightInfo.fromJson(item));
          }
        }
      }

      // XỬ LÝ MẢNG 'RETURN' (Chiều về nội địa)
      if (listAirport['return'] is List) {
        for (var item in listAirport['return']) {
          if (item is Map<String, dynamic>) {
            returnList.add(FlightInfo.fromJson(item));
          }
        }
      }

      return FlightSearchResponse(
        outboundFlights: outboundList,
        returnFlights: returnList,
        internationalPairs: internationalPairs,
      );
    } catch (e) {
      debugPrint("❌ Lỗi parse dữ liệu hãng $airline: $e");
      return FlightSearchResponse();
    }
  }
}
