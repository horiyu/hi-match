import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/notification/type/notification.dart';
import '../../infrastructure/notification_api/provider.dart';

class NotificationListNotifier extends AsyncNotifier<List<MyNotification>> {
  @override
  Future<List<MyNotification>> build() async {
    final api = ref.read(notificationApiProvider);
    return api.getNotifications();
  }
}
