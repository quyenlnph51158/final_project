import '../../../../core/constants/colors.dart';

class BookingUIState {
  final TravelTab selectedTab;
  final FlightTab selectedFlightTab;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final bool isInitialized;

  const BookingUIState({
    required this.selectedTab,
    required this.selectedFlightTab,
    required this.isLoading,
    required this.isSearching,
    this.errorMessage,
    required this.isInitialized,
  });

  factory BookingUIState.initial() {
    return const BookingUIState(
      selectedTab: TravelTab.tour,
      selectedFlightTab: FlightTab.flight,
      isLoading: true,
      isSearching: false,
      isInitialized: false,
    );
  }

  BookingUIState copyWith({
    TravelTab? selectedTab,
    FlightTab? selectedFlightTab,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return BookingUIState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
