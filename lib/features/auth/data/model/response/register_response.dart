class RegisterResponse {
  final int? status;
  final String? msg;
  final String? message;

  RegisterResponse({this.status, this.msg, this.message});

  // ⭐ THÊM DÒNG NÀY ĐỂ HẾT LỖI ⭐
  bool get isSuccess => status == 1;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(status: json['status'], msg: json['msg'], message: json['message']);
  }
}
