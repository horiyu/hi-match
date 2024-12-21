import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/credential/types/credential.dart';
import '../../domain/credential/types/sign_in_with.dart';
import 'interface.dart';

class ImplDev implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final streamController = StreamController<Credential?>();

  @override
  Stream<Credential?> watchCredential() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        streamController.sink.add(
          Credential(
            accessToken: user.refreshToken ?? '',
            refreshToken: user.refreshToken ?? '',
            userID: user.uid,
          ),
        );
      } else {
        streamController.sink.add(null);
      }
    });
    return streamController.stream;
  }

  @override
  Future<bool> isSignedIn() async {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<void> signIn(SignInWith signInWith) async {
    switch (signInWith) {
      case SignInWith.google:
        // Googleサインインの実装を追加
        break;
      // case SignInWith.apple:
      //   // Appleサインインの実装を追加
      //   break;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    streamController.sink.add(null);
  }
}
