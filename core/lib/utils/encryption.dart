import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionFlutter {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(8);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypt = encrypter.encrypt(text, iv: iv);

    return encrypt.base64;
  }

  static decryptAES(text) {
    return encrypter.decrypt64(text, iv: iv);
  }
}
