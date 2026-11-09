// Raw exception types thrown by the API client layer
// These are caught and mapped to Failure types at the repository boundary
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final String? requestId;
  const AppException(this.message, {this.statusCode, this.code, this.requestId});

  @override
  String toString() => 'AppException($statusCode, $code): $message';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Unauthorized', statusCode: 401);
}

class TooManyRequestsException extends AppException {
  final Duration? retryAfter;
  const TooManyRequestsException({this.retryAfter}) : super('Rate limited', statusCode: 429);
}
