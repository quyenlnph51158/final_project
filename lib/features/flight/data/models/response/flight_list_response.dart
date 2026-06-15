import '../flight_item.dart';

class FlightData {
  String? payload;
  List<FlightItem>? lsFlightGo;
  List<FlightItem>? lsFlightReturn;

  FlightData({this.payload, this.lsFlightGo, this.lsFlightReturn});

  FlightData.fromJson(Map<String, dynamic> json) {
    payload = json['payload'];
    if (json['lsFlightGo'] != null) {
      lsFlightGo = (json['lsFlightGo'] as List).map((v) {
        final item = FlightItem.fromJson(v);
        item.payload = payload; // <--- GẮN PAYLOAD VÀO ĐÂY
        return item;
      }).toList();
    }
    if (json['lsFlightReturn'] != null) {
      lsFlightReturn = (json['lsFlightReturn'] as List).map((v) {
        final item = FlightItem.fromJson(v);
        item.payload = payload; // <--- GẮN PAYLOAD VÀO ĐÂY
        return item;
      }).toList();
    }
  }
  FlightData.manual({
    List<FlightItem>? lsFlightGo,
    List<FlightItem>? lsFlightReturn,
  }) : this(lsFlightGo: lsFlightGo, lsFlightReturn: lsFlightReturn);
}

class FlightListResponse {
  int? status;
  dynamic requestId;
  String? message;
  FlightData? data;

  FlightListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    message = json['message'];
    data = json['data'] != null ? FlightData.fromJson(json['data']) : null;
  }
}