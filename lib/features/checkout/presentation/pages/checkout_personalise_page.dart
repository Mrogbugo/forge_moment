import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/checkout_repository.dart';
import '../blocs/checkout_bloc.dart';

class CheckoutPersonalisePage extends StatelessWidget {
  const CheckoutPersonalisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(repository: GetIt.instance<CheckoutRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Personalise')),
        body: const Center(child: Text('Coming soon')),
      ),
    );
  }
}
