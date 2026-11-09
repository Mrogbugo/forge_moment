import 'package:flutter/material.dart';

class GiftSuccessPage extends StatelessWidget {
  final String giftId;
  final String publicLink;
  final String recipientName;
  const GiftSuccessPage({
    super.key,
    required this.giftId,
    required this.publicLink,
    required this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moment Sent')),
      body: const Center(child: Text('Coming soon')),
    );
  }
}
