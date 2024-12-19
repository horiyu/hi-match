import '../../domain/credential/types/credential.dart';
import '../../domain/credential/types/sign_in_with.dart';

abstract interface class Auth {
  // 認証の変化を監視
  Stream<Credential?> watchCredential();

  // サインインしているかどうか
  Future<bool> isSignedIn();

  // サインインを実行
  Future<void> signIn(SignInWith signInWith);

  // サインアウトを実行
  Future<void> signOut();
}
