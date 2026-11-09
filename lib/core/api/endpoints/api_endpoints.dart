// All /api/v1 endpoint paths — single source of truth
// Keep in sync with the FastAPI OpenAPI schema (Section 10.1 of FRD)
class ApiEndpoints {
  ApiEndpoints._();

  static const String _base = '/api/v1';

  // Auth
  static const String register = '$_base/auth/register';
  static const String login = '$_base/auth/login';
  static const String refresh = '$_base/auth/refresh';
  static const String logout = '$_base/auth/logout';
  static const String otpRequest = '$_base/auth/otp/request';
  static const String otpVerify = '$_base/auth/otp/verify';
  static const String passwordReset = '$_base/auth/password/reset';
  static const String socialAuth = '$_base/auth/social';
  static const String guestCreate = '$_base/auth/guest';
  static const String guestConvert = '$_base/auth/guest/convert';
  static const String twoFa = '$_base/auth/2fa';

  // User
  static const String me = '$_base/users/me';
  static const String meAvatar = '$_base/users/me/avatar';
  static const String meSettings = '$_base/users/me/settings';
  static const String meDashboard = '$_base/users/me/dashboard';
  static const String celebrations = '$_base/users/me/celebrations';
  static const String upcomingCelebrations = '$_base/users/me/celebrations/upcoming';
  static const String scheduleGift = '$_base/users/me/celebrations/schedule-gift';

  // Gifts
  static const String gifts = '$_base/gifts';
  static const String giftTemplates = '$_base/gifts/templates';
  static const String giftMusic = '$_base/gifts/music';
  static const String giftSend = '$_base/gifts/{id}/send';
  static const String giftPaymentVerify = '$_base/gifts/{id}/payment/verify';
  static const String giftSent = '$_base/gifts/sent';
  static const String giftReceived = '$_base/gifts/received';
  static const String giftIdeas = '$_base/gifts/ideas';

  // Airtime
  static const String airtimePool = '$_base/airtime/pools';
  static const String airtimePaymentVerify = '$_base/airtime/pools/{id}/payment/verify';
  static const String airtimePublic = '$_base/airtime/pools/{id}/public';

  // Store
  static const String storeCategories = '$_base/store/categories';
  static const String storeProducts = '$_base/store/products';
  static const String storeProduct = '$_base/store/products/{id}';
  static const String storeProductReviews = '$_base/store/products/{id}/reviews';
  static const String storeSuggestions = '$_base/store/suggestions';
  static const String deliveryPricing = '$_base/store/delivery-pricing';
  static const String packaging = '$_base/store/packaging';

  // Orders
  static const String orders = '$_base/orders';
  static const String orderDetail = '$_base/orders/{id}';
  static const String orderCancel = '$_base/orders/{id}/cancel';
  static const String orderTracking = '$_base/orders/{id}/tracking';
  static const String orderPaymentVerify = '$_base/orders/{id}/payment/verify';

  // Wallet
  static const String wallet = '$_base/wallet';
  static const String walletFund = '$_base/wallet/fund';
  static const String walletFundVerify = '$_base/wallet/fund/verify/{reference}';
  static const String walletFundReconcile = '$_base/wallet/fund/reconcile';
  static const String walletTransactions = '$_base/wallet/transactions';
  static const String walletPin = '$_base/wallet/pin';
  static const String walletWithdrawConfig = '$_base/wallet/withdraw/config';
  static const String walletWithdrawOtp = '$_base/wallet/withdraw/otp';
  static const String walletWithdraw = '$_base/wallet/withdraw';
  static const String walletKyc = '$_base/wallet/kyc';
  static const String walletBanks = '$_base/wallet/banks';
  static const String walletAccountVerify = '$_base/wallet/account/verify';

  // Notifications
  static const String notifications = '$_base/notifications';
  static const String notificationsUnread = '$_base/notifications/unread-count';
  static const String notificationRead = '$_base/notifications/{id}/read';
  static const String notificationsReadAll = '$_base/notifications/read-all';
  static const String notificationPreferences = '$_base/notifications/preferences';
  static const String deviceTokens = '$_base/notifications/device-tokens';
}
