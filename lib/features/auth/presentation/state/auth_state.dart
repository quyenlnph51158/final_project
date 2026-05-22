import 'package:final_project/features/auth/data/model/user_model.dart';
import 'package:final_project/features/auth/presentation/state/auth_ui_state.dart';
import 'package:final_project/features/auth/presentation/state/login_state.dart';
import 'package:final_project/features/auth/presentation/state/register_state.dart';

class AuthState {
  final AuthUiState ui;
  final LoginState loginState;
  final RegisterState registerState;
  final UserModel? user;
  AuthState({
    required this.ui,
    required this.loginState,
    required this.registerState,
    this.user
  });
  factory AuthState.initial(){
    return AuthState(
        ui: AuthUiState.initial(),
        loginState: LoginState.initial(),
        registerState: RegisterState.initial(),
        user: null,
    );
  }
  AuthState copyWith({
    AuthUiState? ui,
    LoginState? loginState,
    RegisterState? registerState,
    UserModel? user,
  }){
    return AuthState(
        ui: ui ?? this.ui,
        loginState: loginState ?? this.loginState,
        registerState: registerState ?? this.registerState,
        user: user ?? this.user,
    );
  }
}