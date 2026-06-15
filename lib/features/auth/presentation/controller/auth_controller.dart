import 'package:final_project/core/navigation/navigation_service.dart';
import 'package:final_project/features/auth/data/model/request/register_request.dart';
import 'package:final_project/features/auth/data/service/login_service.dart';
import 'package:final_project/features/auth/data/service/register_service.dart';
import 'package:final_project/features/auth/data/service/secure_credential_service.dart';
import 'package:final_project/features/auth/data/service/token_service.dart';
import 'package:final_project/features/auth/presentation/state/auth_state.dart';
import 'package:final_project/features/auth/presentation/state/auth_ui_state.dart';
import 'package:final_project/features/auth/presentation/state/login_state.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.initial();

  AuthState get state => _state;
  String? _token;
  String? _user;
  String? get token => _token;
  String? get user => _user;

  final LoginService _loginService = LoginService();
  final RegisterService _registerService = RegisterService();

  final TextEditingController accountTxtController = TextEditingController();
  final TextEditingController passWordTxtController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerPhoneNumberController =
      TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController registerConfirmPasswordController =
      TextEditingController();

  Future<void> init() async {
    final hasToken = await TokenService.hasToken();
    if(hasToken){
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          isLoggedIn: hasToken,
        ),
      ),
    );}
    final success = await _loginService.silentLogin();
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          isLoggedIn: success,
        ),
      ),
    );
  }

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loginApp() async {
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(isLoading: true),
        loginState: _state.loginState.copyWith(
          account: accountTxtController.text,
          password: passWordTxtController.text,
        ),
      ),
    );
    try {
      final authResponse = await _loginService.login(
        accountTxtController.text,
        passWordTxtController.text,
      );
      if (authResponse != null) {
        await TokenService.saveToken(authResponse.accessToken, authResponse.user);
        _token = authResponse.accessToken;
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(
              isLoading: false,
              isLoggedIn: true,
              error: null,
            ),
            user: authResponse.user,
          ),
        );
        NavigationService.push(
          MaterialPageRoute(builder: (_) => TravelBookingScreen())
        );
      }
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            isLoggedIn: false,
            isLoading: false,
            error: e.toString(),
          ),
        ),
      );
    }
  }

  Future<bool> register() async {
    // 1. Tạo request từ controller
    RegisterRequest request = RegisterRequest(
      name: registerNameController.text,
      password: registerPasswordController.text,
      confirmPassword: registerConfirmPasswordController.text,
      phone: registerPhoneNumberController.text,
    );
    // 2. Gọi service và đợi kết quả
    // Giả sử service trả về String "msg" khi thành công (status: 1)
    final responseMsg = await _registerService.register(request);

    if (responseMsg.status == 1) {
      // 3. Cập nhật State thành công
      _updateState(
        _state.copyWith(
          registerState: _state.registerState.copyWith(
            apiResponseRegister: responseMsg.msg, // Lưu message thành công
            // Bạn có thể thêm biến error: null ở đây để clear lỗi cũ
          ),
        ),
      );

      return true; // Trả về true để UI biết là thành công
    } else {
      // 4. Xử lý khi có lỗi (Từ throw ở Service)
      _updateState(
        _state.copyWith(
          registerState: _state.registerState.copyWith(
            apiResponseRegister: responseMsg.message, // Lưu message lỗi vào đây
          ),
        ),
      );
      return false; // Trả về false để UI biết là thất bại
    }
  }



  Future<void> logOut() async {
    accountTxtController.clear();
    passWordTxtController.clear();

    await TokenService.deleteToken();
    await SecureCredentialService().clearCredentials();
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();await prefs.clear();
    _updateState(
      _state.copyWith(
        ui: AuthUiState.initial(),
        loginState: LoginState.initial(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    accountTxtController.dispose();
    passWordTxtController.dispose();
    registerNameController.dispose();
    registerPhoneNumberController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
  }
}
