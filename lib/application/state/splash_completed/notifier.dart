import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../external/firebase_core/provider.dart';
// import '../../external/system_locale/provider.dart';
// import '../logger.dart';
import 'models.dart';

class SplashCompletedNotifier extends AsyncNotifier<SplashCompleted> {
  @override
  Future<SplashCompleted> build() async {
    // stateLogger.info('アプリの初期化を開始します');

    // TODO:とりあえず3秒待つ
    await Future.delayed(const Duration(seconds: 3));

    // final firebaseCore = ref.read(firebaseCoreProvider);
    // await firebaseCore.init();

    // final systemLocale = ref.read(systemLocaleProvider);
    // await systemLocale.init();

    // stateLogger.info('アプリの初期化が完了しました');

    return SplashCompleted();
  }
}
