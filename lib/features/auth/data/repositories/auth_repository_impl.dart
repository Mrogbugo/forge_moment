import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../core/auth/session_coordinator_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;
  final SessionCoordinatorImpl _session;
  AuthRepositoryImpl({required ApiClient api, required SessionCoordinatorImpl session})
      : _api = api, _session = session;

  AppUser _parseUser(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        displayName: json['display_name'] as String? ?? json['name'] as String? ?? '',
        email: json['email'] as String,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        twoFaEnabled: json['two_fa_enabled'] as bool? ?? false,
        kycStatus: json['kyc_status'] as String?,
      );

  @override
  Future<AppUser> register({required String displayName, required String email, required String password, String? phone}) async {
    final res = await _api.post(ApiEndpoints.register, body: {'display_name': displayName, 'email': email, 'password': password, if (phone != null) 'phone': phone});
    await _session.onLoginSuccess(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    final res = await _api.post(ApiEndpoints.login, body: {'email': email, 'password': password});
    await _session.onLoginSuccess(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<AppUser> loginWithGoogle(String idToken) async {
    final res = await _api.post(ApiEndpoints.socialAuth, body: {'provider': 'google', 'id_token': idToken});
    await _session.onLoginSuccess(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> requestOtp(String email) => _api.post(ApiEndpoints.otpRequest, body: {'email': email});

  @override
  Future<AppUser> loginWithOtp({required String email, required String otp}) async {
    final res = await _api.post(ApiEndpoints.otpVerify, body: {'email': email, 'otp': otp});
    await _session.onLoginSuccess(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> requestPasswordReset(String email) => _api.post(ApiEndpoints.passwordReset, body: {'email': email});

  @override
  Future<void> confirmPasswordReset({required String email, required String otp, required String newPassword}) =>
      _api.post(ApiEndpoints.passwordReset, body: {'email': email, 'otp': otp, 'new_password': newPassword});

  @override
  Future<AppUser> createGuestSession() async {
    final res = await _api.post(ApiEndpoints.guestCreate);
    await _session.onLoginSuccess(accessToken: res['access_token'] as String, refreshToken: '', isGuest: true);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<AppUser> convertGuestToAccount({required String displayName, required String email, required String password}) async {
    final res = await _api.post(ApiEndpoints.guestConvert, body: {'display_name': displayName, 'email': email, 'password': password});
    await _session.onGuestConverted(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _parseUser(res['user'] as Map<String, dynamic>);
  }

  @override
  Future<AppUser> getCurrentUser() async {
    final res = await _api.get(ApiEndpoints.me);
    return _parseUser(res);
  }

  @override
  Future<Map<String, dynamic>> setup2FA() => _api.post(ApiEndpoints.twoFa);

  @override
  Future<void> verify2FA(String totpCode) => _api.post('${ApiEndpoints.twoFa}/verify', body: {'code': totpCode});

  @override
  Future<void> logout() => _session.logout();
}
