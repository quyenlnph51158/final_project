import '../../../../core/constants/colors.dart';

class FlightUiState {
  final bool isLoading;
  final bool isInitialized;final FlightTab selectedFlightTab;
  final bool isViewingReturnFlights; // Chỉ dùng cho nội địa khứ hồi
  final String? errorMessage;

  const FlightUiState({
    this.isLoading = false,
    this.isInitialized = false,
    this.selectedFlightTab = FlightTab.flight,
    this.isViewingReturnFlights = false,
    this.errorMessage,
  });

  factory FlightUiState.initial() => const FlightUiState(isLoading: true);

  FlightUiState copyWith({
    bool? isLoading, bool? isInitialized,
    FlightTab? selectedFlightTab, bool? isViewingReturnFlights,
    String? errorMessage,
  }) => FlightUiState(
    isLoading: isLoading ?? this.isLoading,
    isInitialized: isInitialized ?? this.isInitialized,
    selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
    isViewingReturnFlights: isViewingReturnFlights ?? this.isViewingReturnFlights,
    errorMessage: errorMessage, // Reset error nếu không truyền
  );
}