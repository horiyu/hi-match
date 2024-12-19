import 'dart:async';

import '../../domain/credential/types/credential.dart';
import '../../domain/credential/types/sign_in_with.dart';
import 'interface.dart';

class ImplDev implements Auth {
  final streamController = StreamController<Credential?>();

  @override
  Stream<Credential?> watchCredential() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      streamController.sink.add(
        const Credential(
          accessToken: 'テストトークン',
          refreshToken: 'テストリフレッシュトークン',
          userID: 'TEST_USER_ID',
        ),
      );
    });
    return streamController.stream;
  }

  @override
  Future<bool> isSignedIn() async {
    Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<void> signIn(SignInWith signInWith) async {
    switch (signInWith) {
      case SignInWith.google:
        streamController.sink.add(
          const Credential(
            accessToken: 'テストトークン',
            refreshToken: 'テストリフレッシュトークン',
            userID: 'TEST_GOOGLE_USER_ID',
          ),
        );
        break;
      // case SignInWith.apple:
      //   streamController.sink.add(
      //     const Credential(
      //       accessToken: 'テストトークン',
      //       refreshToken: 'テストリフレッシュトークン',
      //       userID: 'TEST_APPLE_USER_ID',
      //     ),
      //   );
      //   break;
    }
  }

  @override
  Future<void> signOut() async {
    streamController.sink.add(null);
  }
}
