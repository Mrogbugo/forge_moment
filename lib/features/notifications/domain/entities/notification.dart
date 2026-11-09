enum NotificationDestination { gift, order, walletTransaction, celebration, settings }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final NotificationDestination? destination;
  final String? destinationId;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.destination,
    this.destinationId,
    required this.createdAt,
  });
}
