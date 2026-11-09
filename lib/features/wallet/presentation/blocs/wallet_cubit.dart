import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit({required WalletRepository repository})
      : _repository = repository,
        super(WalletState.initial());

  Future<void> loadWallet() async {
    // TODO: implement
  }

  Future<void> loadTransactions({bool refresh = false, String? type}) async {
    // TODO: implement
  }

  Future<void> loadMoreTransactions() async {
    // TODO: implement
  }

  Future<void> initiateFunding(double amount, String channel) async {
    // TODO: implement
  }

  Future<void> verifyFunding(String reference) async {
    // TODO: implement
  }

  Future<void> reconcileFunding(String reference) async {
    // TODO: implement
  }

  Future<void> setPin(String pin) async {
    // TODO: implement
  }

  Future<void> loadWithdrawalConfig() async {
    // TODO: implement
  }

  Future<void> requestWithdrawalOtp() async {
    // TODO: implement
  }

  Future<void> verifyBankAccount({
    required String bankCode,
    required String accountNumber,
  }) async {
    // TODO: implement
  }

  Future<void> submitWithdrawal(Map<String, dynamic> payload) async {
    // TODO: implement
  }

  Future<void> initiateKyc() async {
    // TODO: implement
  }

  void setActiveAction(WalletAction action) {
    // TODO: implement
  }
}
