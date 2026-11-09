part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final Map<String, dynamic>? preferences;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.preferences,
    this.errorMessage,
  });

  factory NotificationsState.initial() => const NotificationsState();

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    Map<String, dynamic>? preferences,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      preferences: preferences ?? this.preferences,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        unreadCount,
        isLoading,
        hasMore,
        currentPage,
        preferences,
        errorMessage,
      ];
}
