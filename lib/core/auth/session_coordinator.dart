// Central session coordinator (FRD Section 18)
// Responsibilities:
//   - Hold in-memory access token reference
//   - Coordinate single synchronized refresh across concurrent requests (FR-AUTH-008)
//   - On refresh failure: clear tokens, preserve safe drafts, route to login (FR-AUTH-009)
//   - Logout: call backend, revoke refresh token, clear Keychain/Keystore (FR-AUTH-010)
//   - Guest session tracking and conversion (FR-AUTH-011, FR-AUTH-012)
abstract class SessionCoordinator {
  Future<String?> getAccessToken();
  Future<void> refreshToken();
  Future<void> logout();
  bool get isAuthenticated;
  bool get isGuest;
}
