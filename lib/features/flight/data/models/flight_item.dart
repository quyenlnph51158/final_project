import 'flight_detail.dart';

class FlightItem {
  bool isMerged; // True nếu là quốc tế/cặp, False nếu là chặng đơn
  FlightDetail? go;
  FlightDetail? returnFlight;
  int? totalFare;
  int? totalCharge;
  int? totalPrice;
  String? currency;
  int? timeTimestamp;
  String? uniqueId;
  String? payload;

  FlightItem({
    required this.isMerged,
    this.go,
    this.returnFlight,
    this.totalFare,
    this.totalCharge,
    this.totalPrice,
    this.currency,
    this.timeTimestamp,
    this.uniqueId,
    this.payload,
  });

  factory FlightItem.fromJson(Map<String, dynamic> json) {
    final String? uId = json['_unique'];
    if (json.containsKey('go')) {
      // LOẠI 1: VÉ QUỐC TẾ / MERGE
      return FlightItem(
        isMerged: true,
        go: FlightDetail.fromJson(json['go'], id: uId),
        returnFlight: json['return'] != null ? FlightDetail.fromJson(json['return'], id: uId) : null,
        totalFare: json['totalFare'],
        totalCharge: json['totalCharge'],
        totalPrice: json['totalPrice'],
        currency: json['currency'],
        timeTimestamp: json['_time'],
        uniqueId: json['_unique'],
      );
    } else {
      // LOẠI 2: VÉ NỘI ĐỊA / LẺ
      FlightDetail detail = FlightDetail.fromJson(json, id: uId);
      return FlightItem(
        isMerged: false,
        go: detail,
        returnFlight: null,
        totalFare: null, // Với vé lẻ, giá nằm trong inventories của 'go'
        totalPrice: null,
        timeTimestamp: json['_time'],
        uniqueId: json['_unique'],
      );
    }
  }
}