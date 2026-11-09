import 'package:flutter/material.dart';

// Primary CTA button — min 44×44pt / 48×48dp for accessibility (FR-12.5)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool destructive;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: destructive
          ? ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error)
          : null,
      child: loading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(label),
    );
  }
}
