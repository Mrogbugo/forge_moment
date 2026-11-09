import '../../../../shared/models/paginated_response.dart';
import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> getWallet();
  Future<Map<String, dynamic>> initiateFunding(double amount, String channel);
  Future<Wallet> verifyFunding(String reference);
  Future<Wallet> reconcileFunding(String reference);
  Future<PaginatedResponse<WalletTransaction>> getTransactions({int page = 1, String? type});
  Future<void> setPin(String pin);
  Future<Map<String, dynamic>> getWithdrawalConfig();
  Future<void> requestWithdrawalOtp();
  Future<Map<String, dynamic>> verifyBankAccount({required String bankCode, required String accountNumber});
  Future<List<Map<String, dynamic>>> getBanks();
  Future<Map<String, dynamic>> submitWithdrawal(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> initiateKyc();
}
