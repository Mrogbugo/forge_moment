import 'crash_reporter.dart';

/// No-op crash reporter stub — Firebase disabled for local dev.
/// Replace with real FirebaseCrashReporterImpl once google-services.json is added.
class FirebaseCrashReporterImpl implements CrashReporter {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> recordError(Object error, StackTrace? stack, {String? screen, bool fatal = false}) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> log(String message) async {}
}
