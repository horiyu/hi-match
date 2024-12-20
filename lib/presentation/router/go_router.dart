import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
import 'package:my_web_app/presentation/pages/sign_in.dart';
import 'package:my_web_app/presentation/pages/sign_up.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
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
      builder: (_, __) => HimaListPage(),
    );

    // サインインしないと見れない画面範囲
    final signedInShell = ShellRoute(
      routes: [
        himaList,
        GoRoute(
          path: '/home',
          builder: (_, __) => HimaListPage(),
        ),
        // GoRoute(
        //   path: '/search',
        //   builder: (_, __) => SearchPage(),
        // ),
        // GoRoute(
        //   path: '/add',
        //   builder: (_, __) => AddPage(),
        // ),
        // GoRoute(
        //   path: '/profile',
        //   builder: (_, __) => ProfilePage(),
        // ),
      ],
      builder: (_, __, child) {
        return SignedInShell(
          builder: (_) => child,
        );
      },
    );

    // スプラッシュが完了したら見れる画面範囲
    final splashCompletedShell = ShellRoute(
      routes: [
        signIn,
        signUp,
        signedInShell,
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
