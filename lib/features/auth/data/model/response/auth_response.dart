import '../user_model.dart';

class AuthResponse {
  final String accessToken;
  final String expired;
  final UserModel user;
  AuthResponse({
    required this.accessToken,
    required this.expired,
    required this.user,
  });
  factory AuthResponse.fromJson(Map<String, dynamic> json){
    return AuthResponse(
        accessToken: json['access_token'] ?? '',
        expired: json['expired'] ?? '',
        user: UserModel.fromJson(json),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = user.toJson();
    data['access_token'] = accessToken;
    data['expired'] = expired;
    return data;
  }
}