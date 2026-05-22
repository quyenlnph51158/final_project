import '../destination.dart';

class TrainResponse {
  final int? status;
  final String? msg;
  final dynamic data;

  TrainResponse({this.status, this.msg, this.data});
  // ⭐ THÊM DÒNG NÀY ĐỂ HẾT LỖI ⭐
  bool get isSuccess => status == 1;
  factory TrainResponse.fromJson(Map<String, dynamic> json) {
    return TrainResponse(
      status: json['status'],
      msg: json['message'],
      data: json['data'],
    );
  }
}