import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final _key = Key.fromUtf8('12345678901234567890123456789012'); // 32 chars
  static final _iv = IV.fromUtf8('1234567890123456'); // 16 chars

  static final _encrypter = Encrypter(AES(_key));

  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(
      plainText,
      iv: _iv,
    );

    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);

    return _encrypter.decrypt(
      encrypted,
      iv: _iv,
    );
  }
}