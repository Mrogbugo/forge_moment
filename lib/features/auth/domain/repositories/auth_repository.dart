import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser> register({
    required String displayName,
    required String email,
    required String password,
    String? phone,
  });
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> loginWithGoogle(String idToken);
  Future<void> requestOtp(String email);
  Future<AppUser> loginWithOtp({required String email, required String otp});
  Future<void> requestPasswordReset(String email);
  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<AppUser> createGuestSession();
  Future<AppUser> convertGuestToAccount({
    required String displayName,
    required String email,
    required String password,
  });
  Future<AppUser> getCurrentUser();
  Future<Map<String, dynamic>> setup2FA();
  Future<void> verify2FA(String totpCode);
  Future<void> logout();
}
