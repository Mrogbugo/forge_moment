part of 'wallet_cubit.dart';

enum WalletAction { none, funding, withdrawal, pinSetup, kyc }

class WalletState extends Equatable {
  final Wallet? wallet;
  final bool isLoadingWallet;
  final List<WalletTransaction> transactions;
  final bool isLoadingTransactions;
  final bool hasMoreTransactions;
  final int transactionsPage;
  final String? transactionTypeFilter;
  final WalletAction activeAction;
  final bool isActionLoading;
  final Map<String, dynamic>? fundingData;
  final Map<String, dynamic>? withdrawalConfig;
  final List<Map<String, dynamic>> banks;
  final String? errorMessage;

  const WalletState({
    this.wallet,
    this.isLoadingWallet = false,
    this.transactions = const [],
    this.isLoadingTransactions = false,
    this.hasMoreTransactions = true,
    this.transactionsPage = 1,
    this.transactionTypeFilter,
    this.activeAction = WalletAction.none,
    this.isActionLoading = false,
    this.fundingData,
    this.withdrawalConfig,
    this.banks = const [],
    this.errorMessage,
  });

  factory WalletState.initial() => const WalletState();

  WalletState copyWith({
    Wallet? wallet,
    bool? isLoadingWallet,
    List<WalletTransaction>? transactions,
    bool? isLoadingTransactions,
    bool? hasMoreTransactions,
    int? transactionsPage,
    String? transactionTypeFilter,
    WalletAction? activeAction,
    bool? isActionLoading,
    Map<String, dynamic>? fundingData,
    Map<String, dynamic>? withdrawalConfig,
    List<Map<String, dynamic>>? banks,
    String? errorMessage,
    bool clearTransactionTypeFilter = false,
    bool clearFundingData = false,
    bool clearError = false,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      transactions: transactions ?? this.transactions,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      transactionsPage: transactionsPage ?? this.transactionsPage,
      transactionTypeFilter: clearTransactionTypeFilter
          ? null
          : (transactionTypeFilter ?? this.transactionTypeFilter),
      activeAction: activeAction ?? this.activeAction,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      fundingData: clearFundingData ? null : (fundingData ?? this.fundingData),
      withdrawalConfig: withdrawalConfig ?? this.withdrawalConfig,
      banks: banks ?? this.banks,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        wallet,
        isLoadingWallet,
        transactions,
        isLoadingTransactions,
        hasMoreTransactions,
        transactionsPage,
        transactionTypeFilter,
        activeAction,
        isActionLoading,
        fundingData,
        withdrawalConfig,
        banks,
        errorMessage,
      ];
}
