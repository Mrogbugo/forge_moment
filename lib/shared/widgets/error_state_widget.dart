import 'package:flutter/material.dart';

// Standard error state (FR-MOB-008)
// Shows: what happened, whether money was charged, next safe action (FR-UX error rules)
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool moneyMayBeInvolved;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.moneyMayBeInvolved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (moneyMayBeInvolved) ...[
              const SizedBox(height: 8),
              Text(
                'No payment has been confirmed. Please verify before trying again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
