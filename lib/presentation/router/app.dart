import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_web_app/firebase/analytics_repository.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
import 'package:my_web_app/presentation/theme/fonts.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var analytics = ref.watch(analyticsRepository);
    var analyticsObserver = ref.watch(analyticsObserverRepository);

    analytics.logAppOpen();

    return MaterialApp(
      title: 'ひマッチ',
      theme: ThemeData(
        fontFamily: BrandText.bodyS.fontFamily,
      ),
      initialRoute: '/',
      navigatorObservers: [analyticsObserver],
      home: const HimaListPage(), // ここにホームページウィジェットを指定
    );
  }
}
