// Remote-controlled feature flags (FR-10.2 / FR-19)
// Fetched from backend bootstrap/remote-config endpoint at launch
// Enables kill switches for: payment methods, airtime creation, wallet withdrawal, min app version
class FeatureFlags {
  final bool walletWithdrawalEnabled;
  final bool airtimeCreationEnabled;
  final bool cardPaymentEnabled;
  final bool bankTransferEnabled;
  final bool contactPickerEnabled;
  final bool biometricUnlockEnabled;
  final String minimumAppVersion;
  final bool maintenanceMode;
  final String maintenanceMessage;

  const FeatureFlags({
    this.walletWithdrawalEnabled = true,
    this.airtimeCreationEnabled = true,
    this.cardPaymentEnabled = true,
    this.bankTransferEnabled = true,
    this.contactPickerEnabled = false, // Phase 1.1
    this.biometricUnlockEnabled = false, // Phase 1.1
    this.minimumAppVersion = '1.0.0',
    this.maintenanceMode = false,
    this.maintenanceMessage = '',
  });

  factory FeatureFlags.fromJson(Map<String, dynamic> json) => FeatureFlags(
        walletWithdrawalEnabled: json['wallet_withdrawal_enabled'] ?? true,
        airtimeCreationEnabled: json['airtime_creation_enabled'] ?? true,
        cardPaymentEnabled: json['card_payment_enabled'] ?? true,
        bankTransferEnabled: json['bank_transfer_enabled'] ?? true,
        minimumAppVersion: json['minimum_app_version'] ?? '1.0.0',
        maintenanceMode: json['maintenance_mode'] ?? false,
        maintenanceMessage: json['maintenance_message'] ?? '',
      );
}
