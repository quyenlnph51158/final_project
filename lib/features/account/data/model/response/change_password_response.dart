
import '../../../../account/data/model/user_model.dart';

class ChangePasswordResponse {
  final int status;
  final String? requestId;
  final String message;
  final UserModel? user;

  ChangePasswordResponse({
    required this.status,
    this.requestId,
    required this.message,
    this.user,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      status: json['status'] ?? 0,
      requestId: json['request_id'],
      message: json['message'] ?? '',
      // Truy cập sâu vào data -> account để lấy thông tin user
      user: json['data'] != null && json['data']['account'] != null
          ? UserModel.fromJson(json['data']['account'])
          : null,
    );
  }
}