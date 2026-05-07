import 'package:encrypt/encrypt.dart' as encrypt;

class CryptoHelper {

  static final key = encrypt.Key.fromUtf8('12345678901234567890123456789012');

  static String encryptText(String plainText) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Return IV + encrypted text together (Base64)
    return "${iv.base64}:${encrypted.base64}";
  }

  static String decryptText(String encryptedPlusIv) {
    final parts = encryptedPlusIv.split(":");
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = parts[1];

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(encrypted, iv: iv);
  }
}
