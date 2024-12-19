import '../../domain/credential/types/credential.dart';
import '../../domain/credential/types/sign_in_with.dart';
import 'interface.dart';

class ImplStg implements Auth {
  @override
  Stream<Credential?> watchCredential() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  @override
  Future<void> signIn(SignInWith signInWith) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
