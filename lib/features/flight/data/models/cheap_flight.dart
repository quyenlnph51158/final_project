import 'airport.dart';

class CheapFlight {
  String? id; // ID từ key của Map
  String? from;
  String? to;
  String? flightClass; // Đổi tên từ 'class'
  String? type;
  String? image;
  String? price;
  String? airlineCode;
  String? airlineName;
  String? logo;
  Airport? origin;
  Airport? destination;

  CheapFlight.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    from = json['from'];
    to = json['to'];
    flightClass = json['class'];
    type = json['type'];
    image = json['image'];
    price = json['price'];
    airlineCode = json['code'];
    airlineName = json['name'];
    logo = json['logo'];
    origin = json['originAirportObject'] != null
        ? Airport.fromJson(json['originAirportObject']) : null;
    destination = json['destinationAirportObject'] != null
        ? Airport.fromJson(json['destinationAirportObject']) : null;
  }
}