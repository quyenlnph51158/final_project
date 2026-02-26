class PassengerState {
  final int adults;
  final int children;
  final int infants;

  PassengerState({
    required this.adults,
    required this.children,
    required this.infants,
  });

  PassengerState copyWith({
    int? adults,
    int? children,
    int? infants,
  }) {
    return PassengerState(
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
    );
  }

  int get totalPassengers => adults + children;
}