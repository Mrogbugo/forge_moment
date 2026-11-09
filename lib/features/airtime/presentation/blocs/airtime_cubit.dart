import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/airtime_pool.dart';
import '../../domain/repositories/airtime_repository.dart';

part 'airtime_state.dart';

/// Drives the airtime pool creation and payment flow.
/// Injected with [AirtimeRepository]; no service locator dependency. — FR-AIR-001
class AirtimeCubit extends Cubit<AirtimeState> {
  final AirtimeRepository _repository;

  AirtimeCubit({required AirtimeRepository repository})
      : _repository = repository,
        super(const AirtimeState.initial());

  // ── Pool creation ─────────────────────────────────────────────────────────

  /// FR-AIR-002: Create a new airtime pool and advance to the payment step.
  Future<void> createPool({
    required double amountPerClaim,
    required int maxClaims,
    String? message,
    bool anonymous = false,
    DateTime? expiresAt,
  }) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      final payload = <String, dynamic>{
        'amount_per_claim': amountPerClaim,
        'max_claims': maxClaims,
        'anonymous': anonymous,
        if (message != null) 'message': message,
        if (expiresAt != null) 'expires_at': expiresAt.toIso8601String(),
      };

      final pool = await _repository.createPool(payload);
      emit(state.copyWith(
        pool: pool,
        step: AirtimeStep.payment,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Payment ───────────────────────────────────────────────────────────────

  /// FR-AIR-004: Initialise Paystack payment for the created pool.
  /// Emits [paymentUrl] when the repository returns a checkout URL.
  Future<void> initializePayment({required String paymentMethod}) async {
    final pool = state.pool;
    if (pool == null) {
      emit(state.copyWith(
        errorMessage: 'Cannot initiate payment: no airtime pool has been created.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await _repository.initializePayment(pool.id, paymentMethod);
      // The repository implementation may return a Paystack redirect URL via a
      // side-channel (e.g. a returned value or a separate endpoint).  If the
      // abstract interface is extended to return a URL, emit it here.
      // For now we stay in the payment step and await verifyPayment. — FR-AIR-004
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Payment verification ──────────────────────────────────────────────────

  /// FR-AIR-005: Verify the Paystack callback reference and advance to success.
  Future<void> verifyPayment(String reference) async {
    final pool = state.pool;
    if (pool == null) {
      emit(state.copyWith(
        errorMessage: 'Cannot verify payment: no airtime pool found.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      final verifiedPool = await _repository.verifyPayment(pool.id, reference);
      emit(state.copyWith(
        pool: verifiedPool,
        step: AirtimeStep.success,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Pool lookup ───────────────────────────────────────────────────────────

  /// FR-AIR-006: Fetch an existing pool by ID (e.g. deep-link into a claim page).
  Future<void> loadPool(String poolId) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      final pool = await _repository.getPool(poolId);
      emit(state.copyWith(
        pool: pool,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  /// Wipe all state so the user can create a fresh pool — FR-AIR-001.
  void reset() => emit(const AirtimeState.initial());
}
