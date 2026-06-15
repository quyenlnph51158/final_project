class AuthUiState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? error;
  AuthUiState({
    required this.error,
    required this.isLoading,
    required this.isLoggedIn
  });

  factory AuthUiState.initial() {
    return AuthUiState(
      error: '',
        isLoading: false,
        isLoggedIn: false);
  }

  AuthUiState copyWith({
    String? error,
    bool? isLoading,
    bool? isLoggedIn}) {
    return AuthUiState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
