// Deep-link / universal-link coordinator (FR-MOB-006)
// Validates incoming link hosts and callback parameters before acting (FR-12.3 security)
// Handled link patterns:
//   /auth/callback       - Google OAuth / OTP return
//   /payment/callback    - Paystack payment return
//   /gift/:id            - Public gift link
//   /airtime/:id         - Airtime Surprise claim
//   /product/:id         - Store product
//   /order/:id           - Order detail
//   /notification/:id    - Notification destination
abstract class DeepLinkCoordinator {
  Stream<DeepLinkEvent> get events;
  Future<void> initialize();
  Future<void> handleUri(Uri uri);
}

sealed class DeepLinkEvent {}
class AuthCallbackEvent extends DeepLinkEvent { final Uri uri; AuthCallbackEvent(this.uri); }
class PaymentCallbackEvent extends DeepLinkEvent { final String reference; PaymentCallbackEvent(this.reference); }
class GiftLinkEvent extends DeepLinkEvent { final String giftId; GiftLinkEvent(this.giftId); }
class AirtimeLinkEvent extends DeepLinkEvent { final String poolId; AirtimeLinkEvent(this.poolId); }
class ProductLinkEvent extends DeepLinkEvent { final String productId; ProductLinkEvent(this.productId); }
class OrderLinkEvent extends DeepLinkEvent { final String orderId; OrderLinkEvent(this.orderId); }
class NotificationLinkEvent extends DeepLinkEvent { final String notificationId; NotificationLinkEvent(this.notificationId); }
