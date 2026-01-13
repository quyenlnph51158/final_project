class PassengerState {
  final int adults;
  final int children;
  final int infants;
  final String selectedClass;

  PassengerState({
    required this.adults,
    required this.children,
    required this.infants,
    required this.selectedClass,
  });

  PassengerState copyWith({
    int? adults,
    int? children,
    int? infants,
    String? selectedClass,
  }) {
    return PassengerState(
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      selectedClass: selectedClass ?? this.selectedClass,
    );
  }

  int get totalPassengers => adults + children;
}