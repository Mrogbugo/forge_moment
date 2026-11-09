import 'package:flutter/material.dart';

// Empty state — always provides a relevant action (FR-UX: "Create a Moment", "Add a Celebration")
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.inbox_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
