part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

// FR-AUTH-001: Email + password login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// FR-AUTH-002: New account registration
class AuthRegisterRequested extends AuthEvent {
  final String displayName;
  final String email;
  final String password;
  final String? phone;

  const AuthRegisterRequested({
    required this.displayName,
    required this.email,
    required this.password,
    this.phone,
  });

  @override
  List<Object?> get props => [displayName, email, password, phone];
}

// FR-AUTH-003: Google OAuth login
class AuthGoogleLoginRequested extends AuthEvent {
  final String idToken;

  const AuthGoogleLoginRequested({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}

// FR-AUTH-004: Request OTP for email-based login
class AuthOtpRequested extends AuthEvent {
  final String email;

  const AuthOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// FR-AUTH-005: Verify OTP and complete email login
class AuthOtpLoginRequested extends AuthEvent {
  final String email;
  final String otp;

  const AuthOtpLoginRequested({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

// FR-AUTH-006: Initiate password reset — send OTP to email
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// FR-AUTH-007: Confirm password reset with OTP + new password
class AuthPasswordResetConfirmed extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const AuthPasswordResetConfirmed({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

// FR-AUTH-008: Create an anonymous guest session
class AuthGuestRequested extends AuthEvent {
  const AuthGuestRequested();

  @override
  List<Object?> get props => [];
}

// FR-AUTH-009: Upgrade guest account to a full account
class AuthGuestConvertRequested extends AuthEvent {
  final String displayName;
  final String email;
  final String password;

  const AuthGuestConvertRequested({
    required this.displayName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [displayName, email, password];
}

// FR-AUTH-010: Begin TOTP 2FA setup — retrieve QR / secret
class AuthTwoFaSetupRequested extends AuthEvent {
  const AuthTwoFaSetupRequested();

  @override
  List<Object?> get props => [];
}

// FR-AUTH-011: Verify TOTP code to complete 2FA enrollment
class AuthTwoFaVerifyRequested extends AuthEvent {
  final String totpCode;

  const AuthTwoFaVerifyRequested({required this.totpCode});

  @override
  List<Object?> get props => [totpCode];
}

// FR-AUTH-012: Logout current user
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  List<Object?> get props => [];
}

// FR-AUTH-013: Restore session on app start
class AuthCurrentUserRequested extends AuthEvent {
  const AuthCurrentUserRequested();

  @override
  List<Object?> get props => [];
}
