import 'package:dio/dio.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:final_project/features/train/data/models/response/train_search_response.dart';
import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:final_project/features/train/data/models/train_payload_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/response/train_response.dart';

class SearchTrainService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
    ),
  );

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
    final token = await TokenService.getToken();
    try {
      final response = await _dio.post(
        '/train/search',
        queryParameters: {
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
      String? payload = trainRes.data['payload'];
      List<TrainModel> departureList = [];
      List<TrainModel> returnList = [];
      if (trainRes.isSuccess && trainRes.data != null) {
        final dynamic rawData = trainRes.data;

        if (rawData is List) {
          departureList = rawData
              .map<TrainModel>(
                (item) => TrainModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        } else if (rawData is Map) {
          final mapData = Map<String, dynamic>.from(rawData);
          if (rawData.containsKey('lsTrainGo') || rawData.containsKey('lsTrainReturn')) {
            if (mapData['lsTrainGo'] != null) {
              departureList = (mapData['lsTrainGo'] as List)
                  .map<TrainModel>(
                    (item) =>
                        TrainModel.fromJson(Map<String, dynamic>.from(item)),
                  )
                  .toList();
            }
            if (mapData['lsTrainReturn'] != null) {
              returnList = (mapData['lsTrainReturn'] as List)
                  .map<TrainModel>(
                    (item) =>
                        TrainModel.fromJson(Map<String, dynamic>.from(item)),
                  )
                  .toList();
            }
          } else {
            departureList = mapData.values
                .map<TrainModel>(
                  (item) =>
                      TrainModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList();
          }
        }
        return TrainSearchResponse(
          DepartureListTrain: departureList,
          ReturnListTrain: returnList,
          payloadTrain: payload
        );
      } else {
        throw Exception(trainRes.msg ?? 'Lỗi không xác định');
      }
    } on DioException catch (e) {
      throw Exception("Lỗi kết nối: ${e.message}");
    } catch (e) {
      throw Exception("Lỗi xử lý dữ liệu CheapJourneys: $e");
    }
  }
}
