import 'dart:async';
import 'package:dio/dio.dart';
import '../config/environment.dart';
import '../error/app_exception.dart';
import 'secure_storage.dart';
import 'session_coordinator.dart';

/// Manages the session lifecycle: token storage, coordinated refresh,
/// guest sessions, and logout (FR-AUTH-007 through FR-AUTH-012).
///
/// Uses a raw [Dio] instance (bypassing [DioApiClient]'s auth interceptor)
/// for refresh calls to avoid circular dependency.
class SessionCoordinatorImpl extends SessionCoordinator {
  final SecureStorage _storage;
  final Dio _rawDio;

  String? _cachedAccessToken;
  bool _authenticated = false;
  bool _guest = false;

  // Coordinates a single refresh across concurrent 401 responses (FR-AUTH-008)
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  // Observers notified on auth state change (router refreshListenable)
  final List<void Function(bool authenticated)> _listeners = [];

  SessionCoordinatorImpl({required SecureStorage storage})
      : _storage = storage,
        _rawDio = Dio(BaseOptions(
          baseUrl: Environment.apiBaseUrl,
          connectTimeout: const Duration(milliseconds: 15000),
          receiveTimeout: const Duration(milliseconds: 15000),
        ));

  @override
  bool get isAuthenticated => _authenticated;

  @override
  bool get isGuest => _guest;

  /// Called once at app start to restore session from secure storage.
  Future<void> restoreSession() async {
    final token = await _storage.read(SecureStorageKeys.accessToken);
    final guestToken = await _storage.read(SecureStorageKeys.guestToken);
    if (token != null) {
      _cachedAccessToken = token;
      _authenticated = true;
      _guest = false;
    } else if (guestToken != null) {
      _cachedAccessToken = guestToken;
      _authenticated = false;
      _guest = true;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null) return _cachedAccessToken;
    final stored = await _storage.read(SecureStorageKeys.accessToken)
        ?? await _storage.read(SecureStorageKeys.guestToken);
    _cachedAccessToken = stored;
    return stored;
  }

  /// Performs one coordinated refresh. Concurrent callers wait on the same
  /// [Completer] so only a single HTTP call is made (FR-AUTH-008).
  @override
  Future<void> refreshToken() async {
    if (_isRefreshing) {
      await _refreshCompleter!.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _storage.read(SecureStorageKeys.refreshToken);
      if (refreshToken == null) throw const UnauthorizedException();

      final response = await _rawDio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data!;
      final newAccess = data['access_token'] as String;
      final newRefresh = data['refresh_token'] as String?;

      _cachedAccessToken = newAccess;
      await _storage.write(SecureStorageKeys.accessToken, newAccess);
      if (newRefresh != null) {
        await _storage.write(SecureStorageKeys.refreshToken, newRefresh);
      }

      _refreshCompleter!.complete();
    } catch (e) {
      // Refresh failed — clear session, preserve safe local drafts (FR-AUTH-009)
      _refreshCompleter!.completeError(e);
      await _clearSession();
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Called after a successful login/register to persist tokens.
  Future<void> onLoginSuccess({
    required String accessToken,
    required String refreshToken,
    bool isGuest = false,
  }) async {
    _cachedAccessToken = accessToken;
    _authenticated = !isGuest;
    _guest = isGuest;

    if (isGuest) {
      await _storage.write(SecureStorageKeys.guestToken, accessToken);
    } else {
      await _storage.write(SecureStorageKeys.accessToken, accessToken);
      await _storage.write(SecureStorageKeys.refreshToken, refreshToken);
    }
    _notifyListeners(_authenticated);
  }

  /// Called on guest → full account conversion (FR-AUTH-011).
  Future<void> onGuestConverted({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.delete(SecureStorageKeys.guestToken);
    _guest = false;
    await onLoginSuccess(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Calls backend logout, revokes refresh token, clears Keychain (FR-AUTH-010).
  @override
  Future<void> logout() async {
    try {
      final token = await getAccessToken();
      final refresh = await _storage.read(SecureStorageKeys.refreshToken);
      if (token != null) {
        await _rawDio.post<void>(
          '/api/v1/auth/logout',
          data: refresh != null ? {'refresh_token': refresh} : null,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (_) {
      // Best-effort — always clear local state even if the server call fails
    } finally {
      await _clearSession();
    }
  }

  Future<void> _clearSession() async {
    _cachedAccessToken = null;
    _authenticated = false;
    _guest = false;
    await _storage.deleteAll();
    _notifyListeners(false);
  }

  void addListener(void Function(bool authenticated) listener) =>
      _listeners.add(listener);

  void removeListener(void Function(bool authenticated) listener) =>
      _listeners.remove(listener);

  void _notifyListeners(bool authenticated) {
    for (final l in _listeners) {
      l(authenticated);
    }
  }
}
