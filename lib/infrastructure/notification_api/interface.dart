import '../../domain/notification/type/notification.dart';

abstract interface class NotificationApi {
  Future<List<MyNotification>> getNotifications();
}
