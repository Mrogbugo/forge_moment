// Crash reporting adapter (FR-12.3)
// Captures: app version, OS, device class, screen, anonymized request ID
// Redacts: tokens, passwords, OTPs, card data, gift content, recipient info
// TODO: wire up Firebase Crashlytics or Sentry
abstract class CrashReporter {
  Future<void> initialize();
  Future<void> recordError(Object error, StackTrace? stack, {String? screen, bool fatal = false});
  Future<void> setCustomKey(String key, Object value);
  Future<void> log(String message);
}
