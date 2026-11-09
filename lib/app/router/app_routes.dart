/// Every route path and name in one place.
/// Use [AppRoutes.named] to navigate; use paths only for deep-link matching.
class AppRoutes {
  AppRoutes._();

  // ── Unauthenticated ──────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

  // ── Shell tabs (bottom nav) ───────────────────────────────────────────────
  static const String home = '/home';
  static const String gifts = '/gifts';
  static const String activity = '/activity';
  static const String profile = '/profile';

  // ── Create flows (push on top of shell) ──────────────────────────────────
  static const String createGift = '/create/gift';
  static const String giftPersonalise = '/create/gift/personalise';
  static const String giftRecipient = '/create/gift/recipient';
  static const String giftReview = '/create/gift/review';
  static const String giftSuccess = '/create/gift/success';
  static const String createDigitalGift = '/create/digital-gift';
  static const String createAirtime = '/create/airtime';
  static const String airtimeSuccess = '/create/airtime/success';
  static const String createMoneyPackage = '/create/money-package';

  // ── Store & cart ─────────────────────────────────────────────────────────
  static const String store = '/store';
  static const String storeFilter = '/store-filter';
  static const String aiConcierge = '/ai-concierge';
  static const String productDetail = '/store/:productId';
  static const String cart = '/cart';
  static const String checkoutPersonalise = '/checkout/personalise';
  static const String checkoutRecipient = '/checkout/recipient';
  static const String checkoutDelivery = '/checkout/delivery';
  static const String checkoutReview = '/checkout/review';

  // ── Orders ───────────────────────────────────────────────────────────────
  static const String orders = '/activity/orders';
  static const String orderDetail = '/activity/orders/:orderId';

  // ── Wallet ───────────────────────────────────────────────────────────────
  static const String wallet = '/activity/wallet';
  static const String fundWallet = '/activity/wallet/fund';
  static const String withdrawal = '/activity/wallet/withdraw';
  static const String transactions = '/activity/wallet/transactions';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = '/activity/notifications';

  // ── Profile sub-pages ────────────────────────────────────────────────────
  static const String celebrations = '/profile/celebrations';
  static const String addCelebration = '/profile/celebrations/new';
  static const String editCelebration = '/profile/celebrations/:celebrationId/edit';
  static const String settings = '/profile/settings';
  static const String security = '/profile/security';
  static const String support = '/profile/support';

  // ── Wishlist ─────────────────────────────────────────────────────────────
  static const String createWishlist = '/wishlist/create';
  static const String shareWishlist = '/wishlist/share/:wishlistId';
  static const String sharedWishlistView = '/wishlist/:wishlistId';

  // ── Deep links (FR-MOB-006) ───────────────────────────────────────────────
  static const String authCallback = '/auth/callback';
  static const String paymentCallback = '/payment/callback';
  static const String publicGift = '/gift/:giftId';
  static const String publicAirtime = '/airtime/:poolId';

  // ── Route names (used with context.goNamed / context.pushNamed) ──────────
  static const String nameSplash = 'splash';
  static const String nameOnboarding = 'onboarding';
  static const String nameLogin = 'login';
  static const String nameRegister = 'register';
  static const String nameRoleSelection = 'role-selection';
  static const String nameOtp = 'otp';
  static const String nameForgotPassword = 'forgot-password';
  static const String nameHome = 'home';
  static const String nameGifts = 'gifts';
  static const String nameActivity = 'activity';
  static const String nameProfile = 'profile';
  static const String nameCreateGift = 'create-gift';
  static const String nameGiftPersonalise = 'gift-personalise';
  static const String nameGiftRecipient = 'gift-recipient';
  static const String nameGiftReview = 'gift-review';
  static const String nameGiftSuccess = 'gift-success';
  static const String nameCreateDigitalGift = 'create-digital-gift';
  static const String nameCreateAirtime = 'create-airtime';
  static const String nameAirtimeSuccess = 'airtime-success';
  static const String nameCreateMoneyPackage = 'create-money-package';
  static const String nameStore = 'store';
  static const String nameStoreFilter = 'store-filter';
  static const String nameAiConcierge = 'ai-concierge';
  static const String nameProductDetail = 'product-detail';
  static const String nameCart = 'cart';
  static const String nameCheckoutPersonalise = 'checkout-personalise';
  static const String nameCheckoutRecipient = 'checkout-recipient';
  static const String nameCheckoutDelivery = 'checkout-delivery';
  static const String nameCheckoutReview = 'checkout-review';
  static const String nameOrders = 'orders';
  static const String nameOrderDetail = 'order-detail';
  static const String nameWallet = 'wallet';
  static const String nameFundWallet = 'fund-wallet';
  static const String nameWithdrawal = 'withdrawal';
  static const String nameTransactions = 'transactions';
  static const String nameNotifications = 'notifications';
  static const String nameCelebrations = 'celebrations';
  static const String nameAddCelebration = 'add-celebration';
  static const String nameEditCelebration = 'edit-celebration';
  static const String nameSettings = 'settings';
  static const String nameSecurity = 'security';
  static const String nameSupport = 'support';
  static const String nameCreateWishlist = 'create-wishlist';
  static const String nameShareWishlist = 'share-wishlist';
  static const String nameSharedWishlistView = 'shared-wishlist-view';
  static const String nameAuthCallback = 'auth-callback';
  static const String namePaymentCallback = 'payment-callback';
  static const String namePublicGift = 'public-gift';
  static const String namePublicAirtime = 'public-airtime';

  /// Paths that require full authentication (guest sessions are allowed on
  /// everything else so gift creation can start before auth — FR-MOB-005).
  static const List<String> _protectedPrefixes = [
    '/activity',
    '/profile',
    '/cart',
    '/checkout',
    '/create/gift/review',
    '/create/airtime',
  ];

  static bool requiresAuth(String location) =>
      _protectedPrefixes.any((p) => location.startsWith(p));
}
