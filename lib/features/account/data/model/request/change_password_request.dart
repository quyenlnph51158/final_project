class ChangePasswordRequest {
  final String password;
  final String newPassword;
  final String rePassword;

  ChangePasswordRequest({
    required this.password,
    required this.newPassword,
    required this.rePassword,
  });

  // Chuyển từ Object sang Map để gửi lên Server (JSON)
  Map<String, dynamic> toJson() {
    return {
      "password": password,
      "new_password": newPassword,
      "re_password": rePassword,
    };
  }

  // Factory để tạo object từ JSON (nếu cần)
  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      password: json['password'] ?? '',
      newPassword: json['new_password'] ?? '',
      rePassword: json['re_password'] ?? '',
    );
  }
}