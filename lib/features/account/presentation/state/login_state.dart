class LoginState {
  final String account;
  final String password;

  LoginState({required this.account, required this.password});

  factory LoginState.initial() {
    return LoginState(account: '', password: '');
  }

  LoginState copyWith({String? account, String? password}) {
    return LoginState(
      account: account ?? this.account,
      password: password ?? this.password,
    );
  }
}
