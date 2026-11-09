import 'package:flutter/material.dart';

enum OtpPurpose { login, passwordReset }

class OtpPage extends StatelessWidget {
  final String email;
  final OtpPurpose purpose;
  const OtpPage({super.key, required this.email, required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: const Center(child: Text('Coming soon')),
    );
  }
}
