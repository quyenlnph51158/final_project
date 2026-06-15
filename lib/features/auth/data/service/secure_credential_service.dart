import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../app/service/encryption_service.dart';

class SecureCredentialService {
  static const _storage = FlutterSecureStorage();

  static const _accountKey = 'user_account';
  static const _passwordKey = 'user_password';

  Future<void> saveCredentials({
    required String account,
    required String password,
  }) async {
    final encryptedPassword = EncryptionService.encryptText(password);

    await _storage.write(
      key: _accountKey,
      value: account,
    );

    await _storage.write(
      key: _passwordKey,
      value: encryptedPassword,
    );
  }

  Future<Map<String, String>?> getCredentials() async {
    final account = await _storage.read(key: _accountKey);
    final encryptedPassword = await _storage.read(key: _passwordKey);

    if (account == null || encryptedPassword == null) {
      return null;
    }

    final password = EncryptionService.decryptText(encryptedPassword);

    return {
      'account': account,
      'password': password,
    };
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _accountKey);
    await _storage.delete(key: _passwordKey);
  }
}