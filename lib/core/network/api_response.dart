import '../../features/tour/data/models/tour_item.dart';

class ApiResponse {
  final int status;
  final String message;
  final List<TourItem> tourList;

  ApiResponse({
    required this.status,
    required this.message,
    required this.tourList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data']?['data'] ?? [];

    return ApiResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      tourList: list
          .where((item) => item is Map<String, dynamic>)
          .map((item) => TourItem.fromJson(item))
          .toList(),
    );
  }
}
