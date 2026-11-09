import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final ApiClient _api;
  WalletRepositoryImpl({required ApiClient api}) : _api = api;

  Wallet _parseWallet(Map<String, dynamic> j) => Wallet(
        id: j['id'] as String,
        availableBalance: (j['available_balance'] as num).toDouble(),
        currency: j['currency'] as String? ?? 'NGN',
        status: WalletStatus.values.firstWhere(
          (s) => s.name == (j['status'] as String? ?? 'active'),
          orElse: () => WalletStatus.active,
        ),
        lastRefreshed: j['last_refreshed'] != null
            ? DateTime.parse(j['last_refreshed'] as String)
            : DateTime.now(),
        withdrawalEligible: j['withdrawal_eligible'] as bool? ?? false,
        withdrawalIneligibleReason: j['withdrawal_ineligible_reason'] as String?,
      );

  WalletTransaction _parseTx(Map<String, dynamic> j) => WalletTransaction(
        id: j['id'] as String,
        reference: j['reference'] as String,
        type: TransactionType.values.firstWhere(
          (t) => t.name == (j['type'] as String? ?? 'credit'),
          orElse: () => TransactionType.credit,
        ),
        amount: (j['amount'] as num).toDouble(),
        status: TransactionStatus.values.firstWhere(
          (s) => s.name == (j['status'] as String? ?? 'completed'),
          orElse: () => TransactionStatus.completed,
        ),
        description: j['description'] as String? ?? '',
        createdAt: DateTime.parse(j['created_at'] as String),
      );

  @override
  Future<Wallet> getWallet() async {
    final res = await _api.get(ApiEndpoints.wallet);
    return _parseWallet(res);
  }

  @override
  Future<Map<String, dynamic>> initiateFunding(double amount, String channel) =>
      _api.post(ApiEndpoints.walletFund, body: {'amount': amount, 'channel': channel});

  @override
  Future<Wallet> verifyFunding(String reference) async {
    final res = await _api.get(
      ApiEndpoints.walletFundVerify.replaceFirst('{reference}', reference),
    );
    return _parseWallet(res);
  }

  @override
  Future<Wallet> reconcileFunding(String reference) async {
    final res = await _api.post(ApiEndpoints.walletFundReconcile, body: {'reference': reference});
    return _parseWallet(res);
  }

  @override
  Future<PaginatedResponse<WalletTransaction>> getTransactions({int page = 1, String? type}) async {
    final res = await _api.get(ApiEndpoints.walletTransactions, query: {
      'page': page.toString(),
      if (type != null) 'type': type,
    });
    return PaginatedResponse.fromJson(res, _parseTx);
  }

  @override
  Future<void> setPin(String pin) =>
      _api.post(ApiEndpoints.walletPin, body: {'pin': pin});

  @override
  Future<Map<String, dynamic>> getWithdrawalConfig() =>
      _api.get(ApiEndpoints.walletWithdrawConfig);

  @override
  Future<void> requestWithdrawalOtp() =>
      _api.post(ApiEndpoints.walletWithdrawOtp, body: {});

  @override
  Future<Map<String, dynamic>> verifyBankAccount({
    required String bankCode,
    required String accountNumber,
  }) =>
      _api.post(ApiEndpoints.walletAccountVerify, body: {
        'bank_code': bankCode,
        'account_number': accountNumber,
      });

  @override
  Future<List<Map<String, dynamic>>> getBanks() async {
    final res = await _api.get(ApiEndpoints.walletBanks);
    return List<Map<String, dynamic>>.from(res['banks'] ?? res['items'] ?? []);
  }

  @override
  Future<Map<String, dynamic>> submitWithdrawal(Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.walletWithdraw, body: payload);

  @override
  Future<Map<String, dynamic>> initiateKyc() =>
      _api.post(ApiEndpoints.walletKyc, body: {});
}
