import '../model/flight_policy_model.dart';

class FlightPolicyData {
  // Chuyển text thành các key định danh
  static const List<FlightPolicyModel> policyFlight = [
    FlightPolicyModel(text: "policy_carryOnBaggage"),
    FlightPolicyModel(text: "policy_changeFlight"),
    FlightPolicyModel(text: "policy_refund"),
  ];
}