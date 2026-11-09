// Analytics event names — from FRD Section 13
// NEVER include: gift messages, recipient contacts, addresses, OTPs,
//                tokens, bank details, or raw KYC data
class AnalyticsEvents {
  AnalyticsEvents._();

  static const String appOpened = 'app_opened';
  static const String onboardingCompleted = 'onboarding_completed';

  static const String authStarted = 'auth_started';
  static const String authCompleted = 'auth_completed';
  static const String authFailed = 'auth_failed';

  static const String giftCreationStarted = 'gift_creation_started';
  static const String templateSelected = 'template_selected';
  static const String giftStepCompleted = 'gift_step_completed';
  static const String giftPaymentStarted = 'gift_payment_started';
  static const String giftPaymentVerified = 'gift_payment_verified';
  static const String giftPaymentFailed = 'gift_payment_failed';
  static const String giftSent = 'gift_sent';
  static const String shareOpened = 'share_opened';
  static const String shareCompleted = 'share_completed';

  static const String airtimePoolCreated = 'airtime_pool_created';

  static const String productViewed = 'product_viewed';
  static const String cartUpdated = 'cart_updated';
  static const String checkoutStepCompleted = 'checkout_step_completed';
  static const String orderCreated = 'order_created';
  static const String orderPaymentVerified = 'order_payment_verified';

  static const String celebrationCreated = 'celebration_created';

  static const String walletFundingStarted = 'wallet_funding_started';
  static const String walletFundingVerified = 'wallet_funding_verified';
  static const String withdrawalStarted = 'withdrawal_started';
  static const String withdrawalCompleted = 'withdrawal_completed';
  static const String withdrawalFailed = 'withdrawal_failed';

  static const String notificationOpened = 'notification_opened';
}
