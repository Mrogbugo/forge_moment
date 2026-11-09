// Push notification service (FR-NOT-005)
// Registers APNs / FCM device token with backend device-token endpoint (FR-10.2 API gap)
// Respects user OS preferences and in-app preferences (FR-NOT-004)
// Lock-screen content avoids monetary / recipient-sensitive detail by default (FR-NOT-006)
// Deduplicates push + in-app events (FR-NOT-007)
// TODO: add firebase_messaging package to pubspec.yaml
abstract class PushNotificationService {
  Future<void> initialize();
  Future<String?> getDeviceToken();
  Future<void> registerToken(String token);
  Future<void> removeToken(String token);
  Stream<PushNotificationPayload> get onMessage;
  Stream<PushNotificationPayload> get onMessageOpenedApp;
}

class PushNotificationPayload {
  final String type;
  final String? destinationId;
  final String? destinationType;
  final Map<String, dynamic> data;
  const PushNotificationPayload({required this.type, this.destinationId, this.destinationType, this.data = const {}});
}
