import '../airport.dart';

class AirportResponse {
  int? status;
  String? message;
  AirportData? data;

  AirportResponse({this.status, this.message, this.data});

  AirportResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AirportData.fromJson(json['data']) : null;
  }
}

class AirportData {
  Map<String, Airport>? mapAirports; // Lưu dạng Map gốc
  List<Airport> listAirports = [];   // Chuyển sẵn sang List để dùng cho UI

  AirportData({this.mapAirports});

  AirportData.fromJson(Map<String, dynamic> json) {
    if (json['listAirport'] != null) {
      mapAirports = {};
      listAirports = [];

      var airportMapRaw = json['listAirport'] as Map<String, dynamic>;

      airportMapRaw.forEach((key, value) {
        Airport airport = Airport.fromJson(value);
        mapAirports![key] = airport;
        listAirports.add(airport);
      });
    }
  }
}