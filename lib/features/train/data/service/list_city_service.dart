// import 'dart:convert';
// import 'dart:ui';
// import 'package:dio/dio.dart';
// import 'package:final_project/features/account/data/service/token_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/list_city.dart';
// import '../models/response/train_response.dart';
//
// class ListCityService {
//   static int callCount = 0;
//   static const _cacheKey = 'list_city_cache';
//   static const _cacheTimeKey = 'list_city_cache_time';
//
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: dotenv.env['BASE_URL'] ?? '',
//       connectTimeout: const Duration(seconds: 10),
//     ),
//
//   );
//
//   ListCityService() {
//     if (kDebugMode) {
//       _dio.interceptors.add(
//         LogInterceptor(
//           request: true,
//           requestHeader: true,
//           requestBody: true,
//           responseBody: true,
//           responseHeader: false,
//           error: true,
//         ),
//       );
//     }
//   }
//
//   Future<List<ListCity>> fetchListCity() async {
//     callCount++;
//
//     debugPrint("");
//     debugPrint("=================================");
//     debugPrint("CALL fetchListCity()");
//     debugPrint("COUNT: $callCount");
//     debugPrint("TIME : ${DateTime.now()}");
//     debugPrint("=================================");
//     debugPrint("");
//
//     debugPrint(StackTrace.current.toString());
//     final prefs = await SharedPreferences.getInstance();
//
//     try {
//       // =========================
//       // 1. CHECK CACHE
//       // =========================
//
//       final cacheJson = prefs.getString(_cacheKey);
//       final cacheTime = prefs.getInt(_cacheTimeKey);
//
//       if (cacheJson != null && cacheTime != null) {
//         final now = DateTime.now().millisecondsSinceEpoch;
//
//         const cacheDuration = 7 * 24 * 60 * 60 * 1000;
//
//         final isCacheValid = now - cacheTime < cacheDuration;
//
//         if (isCacheValid) {
//           debugPrint(">>> LIST CITY FROM CACHE");
//
//           final List decoded = jsonDecode(cacheJson);
//
//           return decoded
//               .map((e) => ListCity.fromJson(Map<String, dynamic>.from(e)))
//               .toList();
//         }
//       }
//
//       // =========================
//       // 2. CALL API
//       // =========================
//
//       debugPrint(">>> LIST CITY FROM API");
//
//       final token = await TokenService.getToken();
//
//       final response = await _dio.get(
//         '/train/list-city',
//         options: Options(
//           headers: {
//             'Access-Token': token,
//           },
//         ),
//         queryParameters: {
//           "locale": PlatformDispatcher.instance.locale.languageCode,
//         },
//         data: {
//           "flag": 1,
//         },
//       );
//
//       final trainRes = TrainResponse(
//         status: response.data['status'] ?? 0,
//         msg: response.data['message'] ?? '',
//         data: response.data['data'],
//       );
//
//       if (trainRes.isSuccess && trainRes.data != null) {
//         final dynamic rawData = trainRes.data['listTrain'];
//
//         List<ListCity> cities = [];
//
//         // API trả List
//         if (rawData is List) {
//           cities = rawData
//               .whereType<Map>()
//               .map<ListCity>(
//                 (item) =>
//                 ListCity.fromJson(Map<String, dynamic>.from(item)),
//           )
//               .toList();
//         }
//
//         // API trả Map
//         else if (rawData is Map) {
//           cities = rawData.values
//               .whereType<Map>()
//               .map<ListCity>(
//                 (item) =>
//                 ListCity.fromJson(Map<String, dynamic>.from(item)),
//           )
//               .toList();
//         } else {
//           throw Exception(
//             'Định dạng "data" không hợp lệ: ${rawData.runtimeType}',
//           );
//         }
//
//         // =========================
//         // 3. SAVE CACHE
//         // =========================
//
//         await prefs.setString(
//           _cacheKey,
//           jsonEncode(
//             cities.map((e) => e.toJson()).toList(),
//           ),
//         );
//
//         await prefs.setInt(
//           _cacheTimeKey,
//           DateTime.now().millisecondsSinceEpoch,
//         );
//
//         return cities;
//       } else {
//         throw Exception(trainRes.msg ?? 'Lỗi không xác định');
//       }
//     } on DioException catch (e) {
//       throw Exception('Lỗi hệ thống: ${e.message}');
//     } catch (e) {
//       throw Exception('Lỗi xử lý dữ liệu: $e');
//     }
//   }
//
//   // OPTIONAL: clear cache
//   Future<void> clearCache() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     await prefs.remove(_cacheKey);
//     await prefs.remove(_cacheTimeKey);
//   }
// }