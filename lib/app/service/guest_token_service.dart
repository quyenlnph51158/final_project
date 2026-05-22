import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GuestTokenService {
  static const _storage = FlutterSecureStorage();
  static const _guestTokenKey = 'guest_access_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _guestTokenKey, value: token);
  }

  Future<void> getToken() async {
    await _storage.read(key: _guestTokenKey);
  }

  Future<void> clearGuestToken() async {
    await _storage.delete(key: _guestTokenKey);
  }

}
