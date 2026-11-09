import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthOtpRequested>(_onOtpRequested);
    on<AuthOtpLoginRequested>(_onOtpLoginRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthPasswordResetConfirmed>(_onPasswordResetConfirmed);
    on<AuthGuestRequested>(_onGuestRequested);
    on<AuthGuestConvertRequested>(_onGuestConvertRequested);
    on<AuthTwoFaSetupRequested>(_onTwoFaSetupRequested);
    on<AuthTwoFaVerifyRequested>(_onTwoFaVerifyRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCurrentUserRequested>(_onCurrentUserRequested);
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-001: Email + password login
  // ---------------------------------------------------------------------------
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-002: New account registration
  // ---------------------------------------------------------------------------
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-003: Google OAuth login
  // ---------------------------------------------------------------------------
  Future<void> _onGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.loginWithGoogle(event.idToken);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-004: Request OTP for email-based login
  // ---------------------------------------------------------------------------
  Future<void> _onOtpRequested(
    AuthOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.requestOtp(event.email);
      emit(AuthOtpSent(email: event.email));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-005: Verify OTP and complete email login
  // ---------------------------------------------------------------------------
  Future<void> _onOtpLoginRequested(
    AuthOtpLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.loginWithOtp(
        email: event.email,
        otp: event.otp,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-006: Initiate password reset — dispatch OTP to email
  // ---------------------------------------------------------------------------
  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.requestPasswordReset(event.email);
      emit(AuthPasswordResetOtpSent(email: event.email));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-007: Confirm password reset with OTP + new password
  // ---------------------------------------------------------------------------
  Future<void> _onPasswordResetConfirmed(
    AuthPasswordResetConfirmed event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.confirmPasswordReset(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      );
      // After a successful reset, the user is unauthenticated — they must log in.
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-008: Create anonymous guest session
  // ---------------------------------------------------------------------------
  Future<void> _onGuestRequested(
    AuthGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.createGuestSession();
      emit(AuthGuest(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-009: Upgrade guest to full account
  // ---------------------------------------------------------------------------
  Future<void> _onGuestConvertRequested(
    AuthGuestConvertRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.convertGuestToAccount(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-010: Begin TOTP 2FA setup
  // ---------------------------------------------------------------------------
  Future<void> _onTwoFaSetupRequested(
    AuthTwoFaSetupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final setupData = await _repository.setup2FA();
      emit(AuthTwoFaSetup(setupData: setupData));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-011: Verify TOTP code to complete 2FA enrollment
  // ---------------------------------------------------------------------------
  Future<void> _onTwoFaVerifyRequested(
    AuthTwoFaVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.verify2FA(event.totpCode);
      // Re-fetch the user so the state reflects twoFaEnabled = true.
      final user = await _repository.getCurrentUser();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-012: Logout
  // ---------------------------------------------------------------------------
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString(), code: null));
    }
  }

  // ---------------------------------------------------------------------------
  // FR-AUTH-013: Restore session on app start
  //
  // Does NOT emit AuthError on failure — a missing/expired session is not an
  // error; it simply means the user is unauthenticated.
  // ---------------------------------------------------------------------------
  Future<void> _onCurrentUserRequested(
    AuthCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.getCurrentUser();
      // Distinguish between a full account and a lingering guest session via
      // the AppUser.isGuest flag.
      if (user.isGuest) {
        emit(AuthGuest(user: user));
      } else {
        emit(AuthAuthenticated(user: user));
      }
    } catch (_) {
      // No stored token, expired token, or network error — treat as logged out.
      emit(const AuthUnauthenticated());
    }
  }
}
