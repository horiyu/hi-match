import 'dart:async';

import '../../domain/notification/type/notification.dart';
import 'interface.dart';

class ImplStg implements NotificationApi {
  @override
  Future<List<MyNotification>> getNotifications() async {
    return [];
  }
}
