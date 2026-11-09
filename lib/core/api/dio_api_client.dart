import 'dart:async';
import 'package:dio/dio.dart';
import '../auth/secure_storage.dart';
import '../auth/session_coordinator.dart';
import '../config/environment.dart';
import '../error/app_exception.dart';
import 'api_client.dart';

/// Concrete Dio implementation of [ApiClient].
///
/// Auth flow (FR-AUTH-008 / FR-API networking):
///   - Attaches Bearer token to every request via interceptor.
///   - On 401: delegates to [SessionCoordinator.refreshToken] (coordinated
///     single refresh), then retries the original request once.
///   - On 429: honours Retry-After header.
///   - Safe GETs retry up to [_maxRetries] times with exponential backoff.
///   - Mutations never retry unless an idempotency key is supplied.
class DioApiClient implements ApiClient {
  final Dio _dio;
  final SessionCoordinator _session;

  static const int _connectTimeoutMs = 15000;
  static const int _receiveTimeoutMs = 30000;
  static const int _maxRetries = 3;

  DioApiClient({required SessionCoordinator session})
      : _session = session,
        _dio = Dio(BaseOptions(
          baseUrl: Environment.apiBaseUrl,
          connectTimeout: const Duration(milliseconds: _connectTimeoutMs),
          receiveTimeout: const Duration(milliseconds: _receiveTimeoutMs),
          // Tolerate extra JSON fields — Dio uses dynamic by default (FR-API)
          responseType: ResponseType.json,
        )) {
    _dio.interceptors.add(_AuthInterceptor(_session));
    _dio.interceptors.add(_RetryInterceptor(_dio, _session));
    if (!Environment.isProduction) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false,
        // NEVER log headers containing tokens (FR-AUTH-015)
        requestHeader: false,
        responseHeader: false,
      ));
    }
  }

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: query,
    );
    return _unwrap(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    String? idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: idempotencyKey != null
          ? Options(headers: {'Idempotency-Key': idempotencyKey})
          : null,
    );
    return _unwrap(response);
  }

  @override
  Future<Map<String, dynamic>> put(String path, {Object? body}) async {
    final response =
        await _dio.put<Map<String, dynamic>>(path, data: body);
    return _unwrap(response);
  }

  @override
  Future<Map<String, dynamic>> patch(String path, {Object? body}) async {
    final response =
        await _dio.patch<Map<String, dynamic>>(path, data: body);
    return _unwrap(response);
  }

  @override
  Future<void> delete(String path) =>
      _dio.delete<void>(path);

  Map<String, dynamic> _unwrap(Response<Map<String, dynamic>> response) =>
      response.data ?? {};
}

// ---------------------------------------------------------------------------
// Auth interceptor — attaches token, retries once after synchronized refresh
// ---------------------------------------------------------------------------
class _AuthInterceptor extends Interceptor {
  final SessionCoordinator _session;
  _AuthInterceptor(this._session);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _session.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        await _session.refreshToken();
        // Retry the original request with the new token
        final token = await _session.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        final retryResponse = await Dio().fetch(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      } catch (_) {
        // Refresh failed — session coordinator already cleared tokens
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const UnauthorizedException(),
            type: DioExceptionType.badResponse,
            response: err.response,
          ),
        );
        return;
      }
    }
    handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// Retry interceptor — exponential backoff for safe GETs; 429 Retry-After
// ---------------------------------------------------------------------------
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  final SessionCoordinator _session;
  static const _safeMethods = {'GET', 'HEAD', 'OPTIONS'};

  _RetryInterceptor(this._dio, this._session);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra['_retry_attempt'] as int?) ?? 0;
    final isSafe = _safeMethods.contains(options.method.toUpperCase());
    final hasIdempotencyKey = options.headers.containsKey('Idempotency-Key');
    final canRetry = isSafe || hasIdempotencyKey;

    // 429 — honour Retry-After (FR-API)
    if (err.response?.statusCode == 429 && canRetry && attempt < 3) {
      final retryAfter = _parseRetryAfter(err.response?.headers);
      await Future.delayed(retryAfter);
      options.extra['_retry_attempt'] = attempt + 1;
      try {
        final response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    // Transient network errors — exponential backoff for safe methods
    if (canRetry &&
        attempt < DioApiClient._maxRetries &&
        _isTransient(err)) {
      final delay = Duration(milliseconds: 500 * (1 << attempt)); // 0.5s, 1s, 2s
      await Future.delayed(delay);
      options.extra['_retry_attempt'] = attempt + 1;
      try {
        final response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    handler.next(err);
  }

  Duration _parseRetryAfter(Headers? headers) {
    final raw = headers?.value('retry-after');
    if (raw == null) return const Duration(seconds: 5);
    final secs = int.tryParse(raw);
    return secs != null ? Duration(seconds: secs) : const Duration(seconds: 5);
  }

  bool _isTransient(DioException err) =>
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.connectionError;
}

// ---------------------------------------------------------------------------
// DioException → AppException mapper (used at repository boundary)
// ---------------------------------------------------------------------------
AppException mapDioError(DioException err) {
  final status = err.response?.statusCode;
  final data = err.response?.data;
  final code = data is Map ? data['code'] as String? : null;
  final requestId = err.response?.headers.value('x-request-id');
  final message = data is Map
      ? (data['message'] ?? data['detail'] ?? 'An error occurred').toString()
      : 'An error occurred';

  return switch (status) {
    401 => const UnauthorizedException(),
    429 => TooManyRequestsException(
        retryAfter: _parseRetryAfterDuration(err.response?.headers),
      ),
    _ => AppException(message, statusCode: status, code: code, requestId: requestId),
  };
}

Duration? _parseRetryAfterDuration(Headers? headers) {
  final raw = headers?.value('retry-after');
  if (raw == null) return null;
  final secs = int.tryParse(raw);
  return secs != null ? Duration(seconds: secs) : null;
}
