import 'dart:convert';

import 'package:final_project/features/auth/data/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();
  static const _keyAccessToken = 'access_token';
  static const _keyUser = 'user';

  static Future<void> saveToken(String token, UserModel user) async {
    await _storage.write(key: _keyAccessToken, value: token);
    await _storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }
  static Future<UserModel?> getUser() async{
    String? userStr = await _storage.read(key: _keyUser);
    if(userStr != null){
      return UserModel.fromJson( jsonDecode(userStr));
    }
    return null;
  }
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyAccessToken);

  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyUser);
  }

  static Future<bool> hasToken() async {
    String? token = await getToken();
    UserModel? userData = await getUser();
    return token != null && token.isNotEmpty && userData != null;
  }
}
