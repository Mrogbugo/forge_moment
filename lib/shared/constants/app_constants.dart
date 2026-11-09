class AppConstants {
  AppConstants._();

  // Gift creation limits (overridden by AppConfig from backend)
  static const int defaultMaxMediaCount = 5;
  static const int defaultMaxMessageLength = 1000;
  static const int defaultMaxInscriptionLength = 80;

  // Debounce
  static const Duration draftAutosaveDebounce = Duration(seconds: 2);
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // Payment
  static const Duration paymentPollInterval = Duration(seconds: 5);
  static const int maxPaymentPollAttempts = 12; // 1 minute total

  // Retry
  static const int maxRetryAttempts = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);

  // Celebrations
  static const int upcomingCelebrationsDays = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Accessibility — minimum touch targets
  static const double minTouchTargetIos = 44.0;  // 44pt
  static const double minTouchTargetAndroid = 48.0; // 48dp
}
