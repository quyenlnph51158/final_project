
import 'package:final_project/features/flight/presentation/state/flight_criteria_state.dart';
import 'package:final_project/features/flight/presentation/state/flight_data_state.dart';
import 'package:final_project/features/flight/presentation/state/flight_filter_state.dart';
import 'package:final_project/features/flight/presentation/state/flight_ui_state.dart';

class FlightState {
  final FlightDataState data;
  final FlightCriteriaState criteria;
  final FlightUiState ui;
  final FlightFilterState filter;

  const FlightState({
    required this.data,
    required this.criteria,
    required this.ui,
    required this.filter
  });

  /// 🔹 State mặc định ban đầu
  factory FlightState.initial() {
    return FlightState(
      data: FlightDataState.initial(),
      criteria: FlightCriteriaState.initial(),
      ui: FlightUiState.initial(),
      filter: FlightFilterState.Initial(),
    );
  }

  /// 🔹 copyWith để update state
  FlightState copyWith({
    FlightDataState? data,
    FlightCriteriaState? criteria,
    FlightUiState? ui,
    FlightFilterState? filter
  }) {
    return FlightState(
      data:  data ?? this.data,
      criteria: criteria ?? this.criteria,
      ui: ui ?? this.ui,
      filter: filter ?? this.filter,
    );
  }
}
