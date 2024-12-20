import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/auth/provider.dart';
// import '../logger.dart';

class DebugEventNotifier extends Notifier<void> {
  @override
  void build() {}

  void executeEvent(int number) {
    // stateLogger.info('---- デバッグイベント ----');
    if (number == 1) {
      // stateLogger.info('DEBUG: 1. 遠隔操作でサインアウト');
      ref.read(authProvider).signOut();
    } else {
      // stateLogger.info('DEBUG: ?. 登録されていないイベントです');
    }
  }
}
