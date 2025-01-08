// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../domain/types/hima_activity.dart';
import '../../../infrastructure/firestore/provider.dart';
import '../../credential/provider.dart';

class HimaActivityNotifier extends AsyncNotifier<List<HimaActivity>> {
  @override
  Future<List<HimaActivity>> build() async {
    // ログ
    // stateLogger.info('ユーザーの一覧を初期化します');

    // Firestore から取得
    final credential = await ref.read(credentialProvider.future);
    if (credential == null) return [];
    final firestore = ref.read(firestoreProvider);
    final himaActivities = await firestore.getHimaActivities(credential.userID);
    return himaActivities;
  }
}
