enum SortFlightOption {
  cheapest,
  fastest,
  best,
  expensive,
  earliestDeparture,
  latestDeparture,
}

class FlightFilterState {
  final List<String> selectedAirlineSystem;
  final List<int> selectedStopPoint;
  final List<String> selectedTimeDeparture;
  final SortFlightOption sortBy;

  const FlightFilterState({
    required this.selectedAirlineSystem,
    required this.selectedStopPoint,
    required this.selectedTimeDeparture,
    required this.sortBy,
  });

  factory FlightFilterState.Initial(){
    return const FlightFilterState(
        selectedAirlineSystem: [],
        selectedStopPoint: [],
        selectedTimeDeparture: [],
        sortBy: SortFlightOption.cheapest
    );
  }
  FlightFilterState copyWith({
    List<String>? selectedAirlineSystem,
    List<int>? selectedStopPoint,
    List<String>? selectedTimeDeparture,
    SortFlightOption? sortBy,
  }){
    return FlightFilterState(
        selectedAirlineSystem: selectedAirlineSystem ?? this.selectedAirlineSystem,
        selectedStopPoint: selectedStopPoint ?? this.selectedStopPoint,
        selectedTimeDeparture: selectedTimeDeparture ?? this.selectedTimeDeparture,
        sortBy: sortBy ?? this.sortBy
    );
  }
}