class TrainUiState {
  final bool isViewingReturnTrain;
  final bool isReturn;
  final bool isSearching;
  final bool isReturnDate;
  final bool isInitialized;
  final bool isLoading;
  final String errorMessage;
  final bool isSelectedDepartureTrain;
  final bool isSelectedReturnTrain;

  TrainUiState({
    required this.isViewingReturnTrain,
    required this.isReturn,
    required this.isSearching,
    required this.isReturnDate,
    required this.isInitialized,
    required this.isLoading,
    required this.errorMessage,
    required this.isSelectedDepartureTrain,
    required this.isSelectedReturnTrain,
  });

  factory TrainUiState.initial() {
    return TrainUiState(
      isViewingReturnTrain: false,
      isReturn: true,
      isSearching: false,
      isReturnDate: false,
      isInitialized: false,
      isLoading: false,
      errorMessage: '',
      isSelectedDepartureTrain: false,
      isSelectedReturnTrain: false,
    );
  }

  TrainUiState copyWith({
    bool? isViewingReturnTrain,
    bool? isReturn,
    bool? isSearching,
    bool? isReturnDate,
    bool? isInitialized,
    bool? isLoading,
    String? errorMessage,
    bool? isSelectedDepartureTrain,
    bool? isSelectedReturnTrain,
  }) {
    return TrainUiState(
      isViewingReturnTrain: isViewingReturnTrain ?? this.isViewingReturnTrain,
      isReturn: isReturn ?? this.isReturn,
      isSearching: isSearching ?? this.isSearching,
      isReturnDate: isReturnDate ?? this.isReturnDate,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSelectedDepartureTrain: isSelectedDepartureTrain ?? this.isSelectedDepartureTrain,
      isSelectedReturnTrain: isSelectedReturnTrain ?? this.isSelectedReturnTrain,
    );
  }
}
