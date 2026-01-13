import 'package:final_project/features/tour/data/models/tour_category.dart';
class ApiResponse {
  final int status;
  final String? requestId;
  final String message;
  final List<TourCategory> data;

  ApiResponse({
    required this.status,
    this.requestId,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Xử lý trường 'data'
    final dataMap = json['data'] as Map<String, dynamic>;
    final dataListJson = dataMap['data'] as List<dynamic>;

    // Ánh xạ List<dynamic> sang List<TourCategory>
    final List<TourCategory> categories = dataListJson
        .map((e) => TourCategory.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      status: json['status'] as int,
      // request_id có thể là null, nên dùng toán tử 'as String?'
      requestId: json['request_id'] as String?,
      message: json['message'] as String,
      data: categories,
    );
  }
}