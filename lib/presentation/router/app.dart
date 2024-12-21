import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_web_app/firebase/analytics_repository.dart';
import 'package:my_web_app/infrastructure/firestore/impl_dev.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
import 'package:my_web_app/presentation/theme/fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../application/state/flavor/provider.dart';
import '../../infrastructure/console/provider.dart';
import 'go_router.dart';
import 'mobile_simulator_view.dart';
import 'pageView.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var analytics = ref.watch(analyticsRepository);
    var analyticsObserver = ref.watch(analyticsObserverRepository);

    final console = ref.watch(consoleProvider);
    final router = ref.watch(goRouterProvider);

    analytics.logAppOpen();
    console.yellow('App.build() called FLAVOR: ${flavor.name}');

    return MaterialApp.router(
      routerDelegate: router.routerDelegate, // GoRouter
      routeInformationParser: router.routeInformationParser, // GoRouter
      routeInformationProvider: router.routeInformationProvider, // GoRouter
      debugShowCheckedModeBanner: false,
      builder: (_, child) {
        return ViewPage();
        // return MobileSimulatorView(
        //   child: ViewPage(),
        // );
      },
      localizationsDelegates:
          AppLocalizations.localizationsDelegates, // localizations
      supportedLocales: AppLocalizations.supportedLocales, // localizations
      locale: Locale(Intl.systemLocale),
      theme: ThemeData(
        fontFamily: BrandFont.general,
      ),
    );

    // return MaterialApp(
    //   title: 'ひマッチ',
    //   theme: ThemeData(
    //     fontFamily: BrandText.bodyS.fontFamily,
    //   ),
    //   initialRoute: '/',
    //   navigatorObservers: [analyticsObserver],
    //   home: HimaListPage(firestore: ImplDev()), // ここでfirestoreインスタンスを渡す
    // );
  }
}
