import 'package:final_project/core/navigation/navigation_service.dart';
import 'package:final_project/features/account/data/model/request/register_request.dart';
import 'package:final_project/features/account/data/model/request/update_profile_request.dart';
import 'package:final_project/features/account/data/service/login_service.dart';
import 'package:final_project/features/account/data/service/register_service.dart';
import 'package:final_project/features/account/data/service/secure_credential_service.dart';
import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:final_project/features/account/data/service/update_profile_service.dart';
import 'package:final_project/features/account/presentation/state/auth_state.dart';
import 'package:final_project/features/account/presentation/state/auth_ui_state.dart';
import 'package:final_project/features/account/presentation/state/login_state.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/request/change_password_request.dart';
import '../../data/service/change_password_service.dart';

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.initial();
  AuthState get state => _state;

  String? _token;
  String? get token => _token;

  final LoginService _loginService = LoginService();
  final RegisterService _registerService = RegisterService();
  final ChangePasswordService _changePasswordService = ChangePasswordService();
  final UpdateProfileService _updateProfileService = UpdateProfileService();
  final SecureCredentialService _secureService = SecureCredentialService();

  // 1. Khai báo các Controller cho giao diện Đổi mật khẩu
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  // Controllers cho UI
  final TextEditingController accountTxtController = TextEditingController();
  final TextEditingController passWordTxtController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerPhoneNumberController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController registerConfirmPasswordController = TextEditingController();

  // 1. CẬP NHẬT HÀM INIT: Lấy lại thông tin User từ bộ nhớ
  Future<void> init() async {
    final hasToken = await TokenService.hasToken();
    if (!hasToken) return;

    // Cập nhật trạng thái loading ban đầu
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoggedIn: true)));

    final success = await _loginService.silentLogin();

    if (success) {
      // LẤY DỮ LIỆU USER ĐÃ LƯU (Quan trọng để hiển thị Profile)
      final savedUser = await TokenService.getUser();
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoggedIn: true),
          user: savedUser, // Gán user vào state
        ),
      );
    } else {
      await logOut(); // Token hết hạn hoặc lỗi -> Logout sạch sẽ
    }
  }

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  // 2. CẬP NHẬT HÀM LOGIN: Điều hướng an toàn hơn
  Future<void> loginApp() async {
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoading: true, error: null)));

    try {
      final authResponse = await _loginService.login(
        accountTxtController.text.trim(),
        passWordTxtController.text.trim(),
      );

      if (authResponse != null) {
        await TokenService.saveToken(authResponse.accessToken, authResponse.user);
        _token = authResponse.accessToken;

        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(isLoading: false, isLoggedIn: true),
            user: authResponse.user,
          ),
        );

        // Xóa sạch lịch sử các màn hình trước và vào Home
        NavigationService.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const TravelBookingScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoggedIn: false, isLoading: false, error: e.toString())));
    }
  }

  // 3. THÊM HÀM CẬP NHẬT THÔNG TIN (Dành cho trang Profile)
  Future<bool> updateProfile({
    required UpdateProfileRequest request,
  }) async {
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoading: true, error: null)));

    try {
      final response = await _updateProfileService.updateProfile(request);

      if (response.status == 1 && response.user != null) {
        final newUser = response.user!;
        final oldPhone = _state.user?.phone;

        // 1. Lưu Profile vào TokenService để hiển thị giao diện
        await TokenService.saveUser(newUser);

        // 2. CẬP NHẬT CREDENTIALS (Sửa lỗi ở đây)
        if (newUser.phone != oldPhone) {
          // Lấy thông tin tài khoản/mật khẩu hiện tại
          final credentials = await _secureService.getCredentials();
          if (credentials != null) {
            // QUAN TRỌNG: Lưu lại Số điện thoại mới VÀ giữ nguyên Mật khẩu cũ
            await _secureService.saveCredentials(
              account: newUser.phone,
              password: credentials['password'], // Không được để trống cái này
            );
            debugPrint("✅ Đã cập nhật số điện thoại mới và mật khẩu cũ vào Credentials");
          }
        }

        // 3. Cập nhật vào State
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(isLoading: false),
            user: newUser,
          ),
        );
        return true;
      } else {
        _updateState(_state.copyWith(
          ui: _state.ui.copyWith(isLoading: false, error: response.message),
        ));
        return false;
      }
    } catch (e) {
      _updateState(_state.copyWith(
        ui: _state.ui.copyWith(isLoading: false, error: "Lỗi hệ thống: ${e.toString()}"),
      ));
      return false;
    }
  }

  Future<bool> register() async {    // 1. Bật trạng thái loading và xóa lỗi cũ (nếu có)
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(isLoading: true, error: null),
      ),
    );

    try {
      // 2. Tạo request từ controller (sử dụng .trim() để tránh khoảng trắng thừa)
      RegisterRequest request = RegisterRequest(
        name: registerNameController.text.trim(),
        phone: registerPhoneNumberController.text.trim(),
        password: registerPasswordController.text,
        confirmPassword: registerConfirmPasswordController.text,
      );

      // 3. Gọi service và đợi kết quả
      final response = await _registerService.register(request);

      if (response.status == 1) {
        // 4. Cập nhật State thành công
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(isLoading: false),
            registerState: _state.registerState.copyWith(
              apiResponseRegister: response.msg ?? "Đăng ký thành công!",
            ),
          ),
        );
        return true;
      } else {
        // 5. Xử lý khi API trả về lỗi (ví dụ: số điện thoại đã tồn tại)
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(isLoading: false),
            registerState: _state.registerState.copyWith(
              apiResponseRegister: response.message ?? "Đăng ký thất bại",
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      // 6. Xử lý lỗi ngoại lệ (mất kết nối, server sập...)
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            isLoading: false,
            error: e.toString(),
          ),
          registerState: _state.registerState.copyWith(
            apiResponseRegister: "Lỗi hệ thống: ${e.toString()}",
          ),
        ),
      );
      return false;
    }
  }

  // 4. CẬP NHẬT HÀM LOGOUT: Xóa Key chọn lọc
  Future<void> logOut() async {
    try {
      accountTxtController.clear();
      passWordTxtController.clear();

      await TokenService.deleteToken();
      await SecureCredentialService().clearCredentials();

      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data'); // Chỉ xóa key user, không xóa prefs.clear()

      _updateState(
        _state.copyWith(
          ui: AuthUiState.initial(),
          loginState: LoginState.initial(),
          user: null,
        ),
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
  // 2. Hàm xử lý Đổi mật khẩu
  Future<bool> changePasswordApp() async {
    // Kiểm tra cơ bản trước khi gọi API
    if (newPassController.text != confirmPassController.text) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(error: "Mật khẩu xác nhận không khớp"),
        ),
      );
      return false;
    }

    if (newPassController.text.length < 6) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(error: "Mật khẩu mới phải có ít nhất 6 ký tự"),
        ),
      );
      return false;
    }

    // Bật loading
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(isLoading: true, error: null),
      ),
    );

    try {
      // Tạo request
      final request = ChangePasswordRequest(
        password: currentPassController.text,
        newPassword: newPassController.text,
        rePassword: confirmPassController.text,
      );

      // Gọi service
      final response = await _changePasswordService.changePassword(request);

      if (response.status == 1) {
        final newUser = response.user  ?? _state.user;
        // --- QUAN TRỌNG: CẬP NHẬT MẬT KHẨU MỚI VÀO CREDENTIALS ---
        if (newUser != null) {
          await _secureService.saveCredentials(
            account: newUser.phone,
            password: newPassController.text, // Lưu mật khẩu MỚI người dùng vừa nhập
          );
          await TokenService.saveUser(newUser);
          debugPrint("✅ Đã cập nhật mật khẩu mới vào bộ nhớ bảo mật");
        }


        // Nếu server trả về thông tin user mới sau khi đổi pass, cập nhật vào state
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(isLoading: false, error: null),
            user: response.user ?? _state.user, // Cập nhật user nếu có
          ),
        );

        // Xóa sạch các ô nhập mật khẩu sau khi thành công
        clearPasswordFields();

        return true; // Trả về true để UI hiển thị thông báo thành công
      } else {
        // Xử lý khi status != 1 (lỗi từ backend)
        _updateState(
          _state.copyWith(
            ui: _state.ui.copyWith(
              isLoading: false,
              error: response.message,
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      // Xử lý lỗi hệ thống/kết nối
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            isLoading: false,
            error: "Đã có lỗi xảy ra: ${e.toString()}",
          ),
        ),
      );
      return false;
    }
  }

  // Hàm xóa dữ liệu các ô nhập mật khẩu
  void clearPasswordFields() {
    currentPassController.clear();
    newPassController.clear();
    confirmPassController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    accountTxtController.dispose();
    passWordTxtController.dispose();
    registerNameController.dispose();
    registerPhoneNumberController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
