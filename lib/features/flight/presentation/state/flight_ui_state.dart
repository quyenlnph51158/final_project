import '../../../../core/constants/colors.dart';

class FlightUiState {
  final bool isSearching;
  final bool isInitialized;
  final TravelTab selectedTab;
  final FlightTab selectedFlightTab;
  final bool isLoading;
  final bool isSearchingFlight;
  final bool isViewingReturnFlights;
  final bool isSelectedInternationalFlight;
  final bool isSelectedOutboundFlight;
  final bool isSelectedReturnFlight;
  final String errorMessage;
  final String flightSearchError;
  const FlightUiState({
    required this.isSearching,
    required this.isInitialized,
    required this.selectedTab,
    required this.selectedFlightTab,
    required this.isLoading,
    required this.isSearchingFlight,
    required this.isViewingReturnFlights,
    required this.isSelectedInternationalFlight,
    required this.isSelectedOutboundFlight,
    required this.isSelectedReturnFlight,
    required this.errorMessage,
    required this.flightSearchError,
  });
  factory FlightUiState.initial() {
    return FlightUiState(
      isSearching: false,
      isInitialized: false,
      selectedTab: TravelTab.flight,
      selectedFlightTab: FlightTab.flight,
      isLoading: true,
      isSearchingFlight: false,
      isViewingReturnFlights: false,
      isSelectedInternationalFlight: false,
      isSelectedOutboundFlight: false,
      isSelectedReturnFlight: false,
      errorMessage: '',
      flightSearchError: '',
    );
  }
  FlightUiState copyWith({
    bool? isSearching,
    bool? isInitialized,
    TravelTab? selectedTab,
    FlightTab? selectedFlightTab,
    bool? isLoading,
    bool? isSearchingFlight,
    bool? isViewingReturnFlights,
    bool? isSelectedInternationalFlight,
    bool? isSelectedOutboundFlight,
    bool? isSelectedReturnFlight,
    String? errorMessage,
    String? flightSearchError,
  }) {
    return FlightUiState(
      isSearching: isSearching ?? this.isSearching,
      isInitialized: isInitialized ?? this.isInitialized,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
      isLoading: isLoading ?? this.isLoading,
      isSearchingFlight: isSearchingFlight ?? this.isSearchingFlight,
      isViewingReturnFlights: isViewingReturnFlights ?? this.isViewingReturnFlights,
      isSelectedInternationalFlight: isSelectedInternationalFlight ?? this.isSelectedInternationalFlight,
      isSelectedOutboundFlight: isSelectedOutboundFlight ?? this.isSelectedOutboundFlight,
      isSelectedReturnFlight: isSelectedReturnFlight ?? this.isSelectedReturnFlight,
      errorMessage: errorMessage ?? this.errorMessage,
      flightSearchError: flightSearchError ?? this.flightSearchError,
    );
  }
}