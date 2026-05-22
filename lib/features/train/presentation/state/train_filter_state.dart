class TrainFilterState {
  final List<String> filterTimeStart;
  final List<String> filterTimeEnd;

  TrainFilterState({
    required this.filterTimeStart,
    required this.filterTimeEnd,
  });

  factory TrainFilterState.initial() {
    return TrainFilterState(
        filterTimeStart: [],
        filterTimeEnd: []
    );
  }
  TrainFilterState copyWith({
    List<String>? filterTimeStart,
    List<String>? filterTimeEnd,
  }){
    return TrainFilterState(
        filterTimeStart: filterTimeStart ?? this.filterTimeStart,
        filterTimeEnd: filterTimeEnd ?? this.filterTimeEnd
    );
  }
}