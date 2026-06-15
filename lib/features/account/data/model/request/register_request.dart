class RegisterRequest {
  final String name;
  final String password;
  final String confirmPassword;
  final String phone;

  RegisterRequest({
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "password": password,
      "confirm_password": confirmPassword,
      "phone": phone,
    };
  }
}