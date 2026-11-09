// Typed API client — wraps HTTP calls to /api/v1
// FR-API: environment-specific base URL, TLS, connect/read timeouts
// FR-AUTH-008: attaches access token; triggers one synchronized refresh on 401
// FR-API: tolerates backward-compatible extra JSON fields
// FR-API: safe GETs may retry with exponential back-off + jitter
// FR-API: mutations do NOT auto-retry unless idempotency key is supplied
//
// TODO: add http / dio package to pubspec.yaml then implement.
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query});
  Future<Map<String, dynamic>> post(String path, {Object? body, String? idempotencyKey});
  Future<Map<String, dynamic>> put(String path, {Object? body});
  Future<Map<String, dynamic>> patch(String path, {Object? body});
  Future<void> delete(String path);
}
