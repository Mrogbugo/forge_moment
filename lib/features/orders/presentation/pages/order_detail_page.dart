import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/orders_repository.dart';
import '../blocs/orders_cubit.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(repository: GetIt.instance<OrdersRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Coming soon')),
      ),
    );
  }
}
