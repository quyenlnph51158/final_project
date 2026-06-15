import '../cheap_flight.dart';

class CheapFlightResponse {
  int? status;
  String? message;
  CheapFlightData? data;

  CheapFlightResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CheapFlightData.fromJson(json['data']) : null;
  }
}

class CheapFlightData {
  List<CheapFlight> listFlights = [];

  CheapFlightData.fromJson(Map<String, dynamic> json) {
    if (json['listCheapFlight'] != null) {
      var mapRaw = json['listCheapFlight'] as Map<String, dynamic>;
      mapRaw.forEach((key, value) {
        listFlights.add(CheapFlight.fromJson(key, value));
      });

      // (Tùy chọn) Sắp xếp danh sách theo giá tăng dần nếu cần
      // listFlights.sort((a, b) => double.parse(a.price!).compareTo(double.parse(b.price!)));
    }
  }
}