
import '../../../../account/data/model/user_model.dart';

class UpdateProfileResponse {
  final int status;
  final String? requestId;
  final String message;
  final UserModel? user;

  UpdateProfileResponse({
    required this.status,
    this.requestId,
    required this.message,
    this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json['status'] ?? 0,
      requestId: json['request_id'],
      message: json['message'] ?? '',
      // Truy cập sâu vào data -> account để lấy thông tin user
      user: json['data'] != null && json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
    );
  }
}