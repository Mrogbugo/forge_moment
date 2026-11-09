// Analytics adapter — enforces PII redaction before any event is dispatched
// Safe properties only (FRD Section 13): platform, version, gift_type, amount_band, etc.
// TODO: wire up Firebase Analytics or equivalent
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
}

// Amount banding — avoids logging raw amounts (privacy)
String bandAmount(num amount) {
  if (amount == 0) return 'zero';
  if (amount < 1000) return 'under_1k';
  if (amount < 5000) return '1k_5k';
  if (amount < 20000) return '5k_20k';
  if (amount < 100000) return '20k_100k';
  return 'over_100k';
}
