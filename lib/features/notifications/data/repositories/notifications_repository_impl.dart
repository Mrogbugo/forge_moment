import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final ApiClient _api;
  NotificationsRepositoryImpl({required ApiClient api}) : _api = api;

  AppNotification _parse(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        isRead: j['is_read'] as bool? ?? false,
        destination: j['destination'] != null
            ? NotificationDestination.values.firstWhere(
                (d) => d.name == j['destination'] as String,
                orElse: () => NotificationDestination.settings,
              )
            : null,
        destinationId: j['destination_id'] as String?,
        createdAt: DateTime.parse(j['created_at'] as String),
      );

  @override
  Future<PaginatedResponse<AppNotification>> getNotifications({int page = 1}) async {
    final res = await _api.get(ApiEndpoints.notifications, query: {'page': page.toString()});
    return PaginatedResponse.fromJson(res, _parse);
  }

  @override
  Future<int> getUnreadCount() async {
    final res = await _api.get(ApiEndpoints.notificationsUnread);
    return res['count'] as int? ?? 0;
  }

  @override
  Future<void> markRead(String notificationId) =>
      _api.post(ApiEndpoints.notificationRead.replaceFirst('{id}', notificationId), body: {});

  @override
  Future<void> markAllRead() =>
      _api.post(ApiEndpoints.notificationsReadAll, body: {});

  @override
  Future<Map<String, dynamic>> getPreferences() =>
      _api.get(ApiEndpoints.notificationPreferences);

  @override
  Future<void> updatePreferences(Map<String, dynamic> preferences) =>
      _api.put(ApiEndpoints.notificationPreferences, body: preferences);
}
