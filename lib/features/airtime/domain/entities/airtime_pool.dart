// FR-AIR-010: lifecycle states
enum AirtimePoolStatus { pendingPayment, active, fullyClaimed, expired, failed }

class AirtimePool {
  final String id;
  final double amountPerClaim;
  final int maxClaims;
  final int claimsMade;
  final AirtimePoolStatus status;
  final String? publicLink;
  final String? message;
  final bool anonymous;
  final DateTime? expiresAt;

  const AirtimePool({
    required this.id,
    required this.amountPerClaim,
    required this.maxClaims,
    required this.claimsMade,
    required this.status,
    this.publicLink,
    this.message,
    this.anonymous = false,
    this.expiresAt,
  });

  int get remainingSlots => maxClaims - claimsMade;
  double get poolFaceValue => amountPerClaim * maxClaims;
}
