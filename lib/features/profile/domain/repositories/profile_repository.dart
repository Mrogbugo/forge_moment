abstract class ProfileRepository {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload);
  Future<String> uploadAvatar(String localPath, {void Function(double)? onProgress});
  Future<Map<String, dynamic>> getSettings();
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> settings);
}
