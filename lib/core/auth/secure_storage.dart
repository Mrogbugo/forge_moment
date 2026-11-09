// Secure token storage — iOS Keychain / Android Keystore-backed (FR-AUTH-007)
// Stores ONLY: access token, refresh token, and other explicitly approved secrets
// NEVER stores: passwords, OTPs, wallet PINs, KYC identifiers (FR-AUTH-015)
// TODO: add flutter_secure_storage package to pubspec.yaml
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

class SecureStorageKeys {
  SecureStorageKeys._();
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String guestToken = 'guest_token';
}
