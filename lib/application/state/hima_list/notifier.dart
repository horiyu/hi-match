// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../domain/types/user.dart';
import '../../../infrastructure/firestore/provider.dart';
import '../user/provider.dart';

class HimaListNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    // ログ
    // stateLogger.info('ユーザーの一覧を初期化します');

    // Firestore から取得
    final firestore = ref.read(firestoreProvider);
    final user = await ref.read(userProvider.future);
    final users = await firestore.getUsers();
    return users;
  }
}
