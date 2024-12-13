import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';

import '../pages/signin_page.dart';
import '../pages/signup_page.dart';
import 'page_path.dart';
import 'signed_in_shell.dart';
import 'splash_completed_shell.dart';

final goRouterProvider = Provider(
  (ref) {
    // サインイン画面
    final signIn = GoRoute(
      path: PagePath.signIn.path,
      name: PagePath.signIn.name,
      builder: (_, __) => const SignInPage(),
    );

    final signUp = GoRoute(
      path: PagePath.signUp.path,
      name: PagePath.signUp.name,
      builder: (_, __) => const SignUpPage(),
    );

    // // ホーム画面
    // final home = GoRoute(
    //   path: PagePath.home.path,
    //   name: PagePath.home.name,
    //   builder: (_, __) => const HimaListPage(),
    // );

    final himaList = GoRoute(
      path: PagePath.himaList.path,
      name: PagePath.himaList.name,
      builder: (_, __) => const HimaListPage(),
    );

    // サインインしないと見れない画面範囲
    final signedInShell = ShellRoute(
      routes: [
        himaList,
      ],
      builder: (_, __, child) {
        return SignedInShell(
          builder: (_) => child,
        );
      },
    );

    // 通知を受け取れる画面範囲
    // final notifiedShell = ShellRoute(
    //   routes: [
    //     signIn,
    //     signedInShell,
    //   ],
    //   builder: (_, __, child) {
    //     return NotifiedShell(
    //       builder: (_) => child,
    //     );
    //   },
    // );

    // メンテナンス中は見れない画面範囲
    // final appMaintShell = ShellRoute(
    //   routes: [
    //     notifiedShell,
    //   ],
    //   builder: (_, __, child) {
    //     return AppMaintShell(
    //       builder: () => child,
    //     );
    //   },
    // );

    // アプリ更新中は見れない画面範囲
    // final appUpdatedShell = ShellRoute(
    //   routes: [
    //     appMaintShell,
    //   ],
    //   builder: (_, __, child) {
    //     return AppUpdatedShell(
    //       builder: (_) => child,
    //     );
    //   },
    // );

    // スプラッシュが完了したら見れる画面範囲
    final splashCompletedShell = ShellRoute(
      routes: [
        // appUpdatedShell,
      ],
      builder: (_, __, child) {
        return SplashCompletedShell(
          builder: () => child,
        );
      },
    );

    return GoRouter(
      initialLocation: PagePath.himaList.path,
      debugLogDiagnostics: false,
      routes: [
        splashCompletedShell,
      ],
    );
  },
);
