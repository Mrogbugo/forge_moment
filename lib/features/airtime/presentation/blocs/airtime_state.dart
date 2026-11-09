part of 'airtime_cubit.dart';

// FR-AIR-001: Three phases of the airtime pool creation flow
enum AirtimeStep {
  form,    // user fills in amount-per-claim, max-claims, message, etc.
  payment, // Paystack checkout in progress
  success, // payment verified — pool is active
}

class AirtimeState extends Equatable {
  // ── Pool data ─────────────────────────────────────────────────────────────
  /// Null until createPool or loadPool succeeds — FR-AIR-002
  final AirtimePool? pool;

  // ── Wizard position ───────────────────────────────────────────────────────
  final AirtimeStep step;

  // ── Async state ───────────────────────────────────────────────────────────
  final bool isLoading;
  final String? errorMessage;

  /// FR-AIR-004: Paystack hosted checkout URL emitted after initializePayment
  final String? paymentUrl;

  const AirtimeState({
    this.pool,
    required this.step,
    required this.isLoading,
    this.errorMessage,
    this.paymentUrl,
  });

  const AirtimeState.initial()
      : pool = null,
        step = AirtimeStep.form,
        isLoading = false,
        errorMessage = null,
        paymentUrl = null;

  AirtimeState copyWith({
    AirtimePool? pool,
    AirtimeStep? step,
    bool? isLoading,
    String? errorMessage,
    String? paymentUrl,
    // Sentinels for nullable fields that must be explicitly clearable
    bool clearPool = false,
    bool clearErrorMessage = false,
    bool clearPaymentUrl = false,
  }) {
    return AirtimeState(
      pool: clearPool ? null : (pool ?? this.pool),
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      paymentUrl: clearPaymentUrl ? null : (paymentUrl ?? this.paymentUrl),
    );
  }

  @override
  List<Object?> get props => [pool, step, isLoading, errorMessage, paymentUrl];
}
