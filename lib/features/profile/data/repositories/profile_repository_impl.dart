import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../core/config/environment.dart';
import '../../../../core/upload/upload_manager.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _api;
  final UploadManager _uploadManager;

  ProfileRepositoryImpl({required ApiClient api, required UploadManager uploadManager})
      : _api = api,
        _uploadManager = uploadManager;

  @override
  Future<Map<String, dynamic>> getProfile() => _api.get(ApiEndpoints.me);

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload) =>
      _api.patch(ApiEndpoints.me, body: payload);

  @override
  Future<String> uploadAvatar(String localPath, {void Function(double)? onProgress}) async {
    final result = await _uploadManager.uploadImage(
      localPath,
      uploadUrl: '${Environment.apiBaseUrl}${ApiEndpoints.meAvatar}',
      onProgress: onProgress,
    );
    return result.remoteUrl;
  }

  @override
  Future<Map<String, dynamic>> getSettings() => _api.get(ApiEndpoints.meSettings);

  @override
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> settings) =>
      _api.put(ApiEndpoints.meSettings, body: settings);
}
