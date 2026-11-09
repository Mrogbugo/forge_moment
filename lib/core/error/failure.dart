sealed class Failure {
  final String message;
  final String? code;
  final String? requestId;
  const Failure(this.message, {this.code, this.requestId});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check and try again.']);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Your session has expired. Please log in again.',
    String? code,
  ]) : super(code: code);
}

class PaymentFailure extends Failure {
  final bool mayHaveBeenCharged;
  const PaymentFailure(super.message, {this.mayHaveBeenCharged = false, super.code, super.requestId});
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on our end. Please try again.',
    String? code,
    String? requestId,
  ]) : super(code: code, requestId: requestId);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested item could not be found.']);
}

class RateLimitFailure extends Failure {
  final Duration? retryAfter;
  const RateLimitFailure([super.message = 'Too many requests. Please wait a moment.', this.retryAfter]);
}

class MaintenanceFailure extends Failure {
  const MaintenanceFailure([super.message = 'Forge Moments is currently undergoing maintenance.']);
}

class ForceUpgradeFailure extends Failure {
  final String storeUrl;
  const ForceUpgradeFailure(super.message, {required this.storeUrl});
}
