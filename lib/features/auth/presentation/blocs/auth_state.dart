part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

// FR-AUTH-013: Initial state before any auth action is taken
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

// Generic loading state — emitted while any request is in flight
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

// FR-AUTH-001 / FR-AUTH-002 / FR-AUTH-003 / FR-AUTH-005: Full authenticated session
class AuthAuthenticated extends AuthState {
  final AppUser user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// FR-AUTH-008: Anonymous guest session active
class AuthGuest extends AuthState {
  final AppUser user;

  const AuthGuest({required this.user});

  @override
  List<Object?> get props => [user];
}

// FR-AUTH-004: OTP dispatched; UI should render the OTP input screen
class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent({required this.email});

  @override
  List<Object?> get props => [email];
}

// FR-AUTH-006: Password-reset OTP dispatched; UI should render OTP + new-password form
class AuthPasswordResetOtpSent extends AuthState {
  final String email;

  const AuthPasswordResetOtpSent({required this.email});

  @override
  List<Object?> get props => [email];
}

// FR-AUTH-010: TOTP setup data returned (contains otpauth URI, QR data, backup codes, etc.)
class AuthTwoFaSetup extends AuthState {
  final Map<String, dynamic> setupData;

  const AuthTwoFaSetup({required this.setupData});

  @override
  List<Object?> get props => [setupData];
}

// FR-AUTH-012 / FR-AUTH-013: No active session
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object?> get props => [];
}

// Emitted whenever a repository call throws; [code] is an optional error code
// returned by the backend (e.g. "EMAIL_NOT_VERIFIED").
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({required this.message, required this.code});

  @override
  List<Object?> get props => [message, code];
}
