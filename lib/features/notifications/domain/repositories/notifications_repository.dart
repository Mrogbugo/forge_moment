import '../../../../shared/models/paginated_response.dart';
import '../entities/notification.dart';

abstract class NotificationsRepository {
  Future<PaginatedResponse<AppNotification>> getNotifications({int page = 1});
  Future<int> getUnreadCount();
  Future<void> markRead(String notificationId);
  Future<void> markAllRead();
  Future<Map<String, dynamic>> getPreferences();
  Future<void> updatePreferences(Map<String, dynamic> preferences);
}
