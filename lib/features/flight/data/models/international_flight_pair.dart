// international_flight_pair.dart
import 'flight_info.dart';
import 'inventory.dart';

class InternationalFlightPair {
  final FlightInfo outbound;
  final FlightInfo returnFlight;
  final int totalPrice;
  final List<InventoryPair> syncedInventories; // Danh sách hạng ghế đã đồng bộ

  InternationalFlightPair({
    required this.outbound,
    required this.returnFlight,
    required this.totalPrice,
    required this.syncedInventories,
  });

  factory InternationalFlightPair.fromJson(Map<String, dynamic> json) {
    final outbound = FlightInfo.fromJson(json['go']);
    final returnFlight = FlightInfo.fromJson(json['return']);

    // LOGIC TỐI ƯU: Tìm các hạng ghế trùng tên giữa đi và về
    List<InventoryPair> pairs = [];
    for (var outInv in outbound.inventories) {
      // Tìm inventory ở lượt về có cùng FareType (Eco, Deluxe...)
      final matchingReturnInv = returnFlight.inventories.firstWhere(
            (retInv) => retInv.fareType == outInv.fareType,
        orElse: () => returnFlight.inventories.first,
      );

      pairs.add(InventoryPair(outbound: outInv, returnFlight: matchingReturnInv));
    }

    return InternationalFlightPair(
      outbound: outbound,
      returnFlight: returnFlight,
      totalPrice: json['totalPrice'] ?? 0,
      syncedInventories: pairs,
    );
  }
}

class InventoryPair {
  final Inventory outbound;
  final Inventory returnFlight;
  InventoryPair({required this.outbound, required this.returnFlight});
}