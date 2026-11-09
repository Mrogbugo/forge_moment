import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/profile_repository.dart';
import '../blocs/profile_cubit.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(repository: GetIt.instance<ProfileRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Security')),
        body: const Center(child: Text('Coming soon')),
      ),
    );
  }
}
