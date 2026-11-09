import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/gifts_repository.dart';
import '../blocs/gift_creation_bloc.dart';

class GiftPersonalizePage extends StatelessWidget {
  const GiftPersonalizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GiftCreationBloc(repository: GetIt.instance<GiftsRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Personalise Your Moment')),
        body: const Center(child: Text('Coming soon')),
      ),
    );
  }
}
