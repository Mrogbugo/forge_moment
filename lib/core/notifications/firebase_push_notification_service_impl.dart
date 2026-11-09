import 'dart:async';
import 'push_notification_service.dart';

/// No-op push notification stub — Firebase disabled for local dev.
/// Replace with real FirebasePushNotificationServiceImpl once google-services.json is added.
class FirebasePushNotificationServiceImpl implements PushNotificationService {
  final _messageController = StreamController<PushNotificationPayload>.broadcast();
  final _openedController = StreamController<PushNotificationPayload>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getDeviceToken() async => null;

  @override
  Future<void> registerToken(String token) async {}

  @override
  Future<void> removeToken(String token) async {}

  @override
  Stream<PushNotificationPayload> get onMessage => _messageController.stream;

  @override
  Stream<PushNotificationPayload> get onMessageOpenedApp => _openedController.stream;

  void dispose() {
    _messageController.close();
    _openedController.close();
  }
}
