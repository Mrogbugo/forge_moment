import 'analytics_service.dart';

/// No-op analytics stub — Firebase disabled for local dev.
/// Replace with FirebaseAnalyticsServiceImpl once google-services.json is added.
class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String? value) async {}
}
