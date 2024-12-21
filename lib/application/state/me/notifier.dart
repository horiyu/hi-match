// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../domain/types/user.dart';
import '../../../infrastructure/firestore/provider.dart';
import '../user/provider.dart';

class MeNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    // ログ
    // stateLogger.info('ユーザーの一覧を初期化します');

    // Firestore から取得
    final firestore = ref.read(firestoreProvider);
    final user = await ref.read(userProvider.future);
    final me = await firestore.findUserByUid(user!.uid);
    return me;
  }
}
