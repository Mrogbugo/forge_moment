// Attaches Bearer token to every protected request (FR-AUTH-008)
// On 401: attempts ONE synchronized refresh; on failure clears session (FR-AUTH-009)
// On 429: honors Retry-After header (FR-API networking)
// TODO: implement once http/dio package is wired up
abstract class AuthInterceptor {}
