import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
import 'package:my_web_app/presentation/pages/profile.dart';
import 'package:my_web_app/presentation/pages/sign_in.dart';
import 'package:my_web_app/presentation/pages/sign_up.dart';
import 'package:my_web_app/presentation/pages/hima_list.dart';
import '../../application/state/me/provider.dart';
import '../../application/state/user/provider.dart';
import '../../domain/types/user.dart';
import '../../infrastructure/auth/provider.dart';
import 'page_view.dart';
import 'page_path.dart';
import 'signed_in_shell.dart';
import 'splash_completed_shell.dart';

final goRouterProvider = Provider(
  (ref) {
    final auth = ref.watch(authProvider);

    // サインイン画面
    final signIn = GoRoute(
      path: PagePath.signIn.path,
      name: PagePath.signIn.name,
      builder: (_, __) => const SignInPage(),
    );

    // サインアップ画面
    final signUp = GoRoute(
      path: PagePath.signUp.path,
      name: PagePath.signUp.name,
      builder: (_, __) => const SignUpPage(),
    );

    // ViewPage
    final viewPage = GoRoute(
      path: PagePath.viewPage.path,
      name: PagePath.viewPage.name,
      builder: (_, __) => ViewPage(),
    );

    // // ホーム画面
    // final home = GoRoute(
    //   path: PagePath.home.path,
    //   name: PagePath.home.name,
    //   builder: (_, __) => const HimaListPage(),
    // );

    // final himaList = GoRoute(
    //   path: PagePath.himaList.path,
    //   name: PagePath.himaList.name,
    //   builder: (_, __) => HimaListPage(),
    // );

    // final meAsyncValue = ref.watch(meProvider);

    final profile = GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) {
        final user = state.extra as User;
        return ProfilePage(user: user);
      },
    );

    // サインインしないと見れない画面範囲
    final signedInShell = ShellRoute(
      routes: [
        // himaList,
        profile,
        viewPage,
        // GoRoute(
        //   path: '/home',
        //   builder: (_, __) => HimaListPage(),
        // ),
        // GoRoute(
        //   path: '/profile',
        //   builder: (_, __) {
        //     return meAsyncValue.when(
        //       data: (user) => ProfilePage(user: user),
        //       loading: () => const CircularProgressIndicator(),
        //       error: (err, stack) => Text('Error: $err'),
        //     );
        //   },
        // ),
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
      // initialLocation: PagePath.himaList.path,
      initialLocation: PagePath.viewPage.path,
      debugLogDiagnostics: false,
      routes: [
        splashCompletedShell,
      ],
      // redirect: (context, state) {
      //   final loggedIn = ref.read(authProvider).isSignedIn as bool;
      //   final goingToSignIn = state.uri.toString() == PagePath.signIn.path;
      //   print('loggedIn: $loggedIn');
      //   print('goingToSignIn: $goingToSignIn');
      //   if (!loggedIn && !goingToSignIn) {
      //     return PagePath.signIn.path;
      //   }
      //   return null;
      // }
    );
  },
);
