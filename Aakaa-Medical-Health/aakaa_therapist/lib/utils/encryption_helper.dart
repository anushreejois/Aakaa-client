import 'dart:convert';

class EncryptionHelper {
  // Symmetric secret key for local clinical notepad encryption
  static const String _key = "aakaa_super_secret_clinical_notepad_key_2026";

  /// Encrypts plain text to a secure base64 ciphertext string
  static String encrypt(String text) {
    if (text.isEmpty) return "";
    final List<int> bytes = utf8.encode(text);
    final List<int> keyBytes = utf8.encode(_key);
    final List<int> encrypted = List<int>.generate(bytes.length, (i) {
      return bytes[i] ^ keyBytes[i % keyBytes.length];
    });
    return base64Url.encode(encrypted);
  }

  /// Decrypts a base64 ciphertext string back to plain text
  static String decrypt(String ciphertext) {
    if (ciphertext.isEmpty) return "";
    try {
      final List<int> bytes = base64Url.decode(ciphertext);
      final List<int> keyBytes = utf8.encode(_key);
      final List<int> decrypted = List<int>.generate(bytes.length, (i) {
        return bytes[i] ^ keyBytes[i % keyBytes.length];
      });
      return utf8.decode(decrypted);
    } catch (e) {
      // In case of parsing error, return raw string to prevent app crashes
      return ciphertext;
    }
  }
}
