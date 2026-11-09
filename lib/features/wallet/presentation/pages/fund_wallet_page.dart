import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/wallet_repository.dart';
import '../blocs/wallet_cubit.dart';

class FundWalletPage extends StatelessWidget {
  const FundWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit(repository: GetIt.instance<WalletRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Fund Wallet')),
        body: const Center(child: Text('Coming soon')),
      ),
    );
  }
}
