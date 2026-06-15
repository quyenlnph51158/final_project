import 'dart:convert';
import 'package:final_project/features/account/data/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();
  static const _keyAccessToken = 'access_token';
  static const _keyUser = 'user';

  /// Lưu cả Token và User (Dùng khi Đăng nhập hoặc Đổi mật khẩu nếu có token mới)
  static Future<void> saveToken(String token, UserModel user) async {
    await _storage.write(key: _keyAccessToken, value: token);
    await _storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }

  /// CHỈ LƯU USER (Dùng khi Cập nhật Profile hoặc thay đổi thông tin nhỏ lẻ)
  /// Điều này giúp giữ nguyên Access Token cũ đang hoạt động
  static Future<void> saveUser(UserModel user) async {
    await _storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }

  /// Lấy thông tin User từ bộ nhớ
  static Future<UserModel?> getUser() async {
    try {
      String? userStr = await _storage.read(key: _keyUser);
      if (userStr != null) {
        return UserModel.fromJson(jsonDecode(userStr));
      }
    } catch (e) {
      // Tránh lỗi khi dữ liệu json bị hỏng
      return null;
    }
    return null;
  }

  /// Lấy Access Token để gắn vào Header các API
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Xóa sạch dữ liệu (Dùng khi Đăng xuất)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyUser);
  }

  /// Kiểm tra xem người dùng đã đăng nhập chưa
  static Future<bool> hasToken() async {
    String? token = await getToken();
    UserModel? userData = await getUser();
    return token != null && token.isNotEmpty && userData != null;
  }
}