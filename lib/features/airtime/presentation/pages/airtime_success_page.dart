import 'package:flutter/material.dart';

class AirtimeSuccessPage extends StatelessWidget {
  final String poolId;
  final String publicLink;
  const AirtimeSuccessPage({
    super.key,
    required this.poolId,
    required this.publicLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airtime Pool Created')),
      body: const Center(child: Text('Coming soon')),
    );
  }
}
