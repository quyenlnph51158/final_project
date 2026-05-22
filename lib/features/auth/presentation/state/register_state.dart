class RegisterState {
  final String apiResponseRegister;
  RegisterState({
    required this.apiResponseRegister,
  });
  factory RegisterState.initial() {
    return RegisterState(
        apiResponseRegister: ''
    );
  }
  RegisterState copyWith({
    String? apiResponseRegister
  }){
    return RegisterState(
        apiResponseRegister: apiResponseRegister ?? this.apiResponseRegister
    );
  }

}