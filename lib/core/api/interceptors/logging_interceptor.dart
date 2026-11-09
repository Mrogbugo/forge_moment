// Logs endpoint group, duration, status/error code, connectivity class
// NEVER logs: tokens, passwords, OTPs, card data, gift messages, recipient contacts (FR-AUTH-015, FR-12.4)
// Captures correlation/request ID for support (FR-12.3)
// TODO: implement once http/dio package is wired up
abstract class LoggingInterceptor {}
