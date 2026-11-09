import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit({required NotificationsRepository repository})
      : _repository = repository,
        super(NotificationsState.initial());

  Future<void> loadNotifications({bool refresh = false}) async {
    // TODO: implement
  }

  Future<void> loadMore() async {
    // TODO: implement
  }

  Future<void> loadUnreadCount() async {
    // TODO: implement
  }

  Future<void> markRead(String notificationId) async {
    // TODO: implement
  }

  Future<void> markAllRead() async {
    // TODO: implement
  }

  Future<void> loadPreferences() async {
    // TODO: implement
  }

  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    // TODO: implement
  }
}
