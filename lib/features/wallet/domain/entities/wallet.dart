enum WalletStatus { active, suspended, pendingKyc }
enum TransactionType { credit, debit, withdrawal, funding, giftSend, refund }
enum TransactionStatus { pending, completed, failed, processing }

class Wallet {
  final String id;
  final double availableBalance;
  final String currency; // NGN
  final WalletStatus status;
  final DateTime lastRefreshed;
  final bool withdrawalEligible;
  final String? withdrawalIneligibleReason;

  const Wallet({
    required this.id,
    required this.availableBalance,
    this.currency = 'NGN',
    required this.status,
    required this.lastRefreshed,
    this.withdrawalEligible = false,
    this.withdrawalIneligibleReason,
  });
}

class WalletTransaction {
  final String id;
  final String reference;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final String description;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.reference,
    required this.type,
    required this.amount,
    required this.status,
    required this.description,
    required this.createdAt,
  });
}
