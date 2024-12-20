import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/credential/types/credential.dart';
import '../../infrastructure/auth/provider.dart';

class CredentialNotifier extends StreamNotifier<Credential?> {
  @override
  Stream<Credential?> build() {
    final auth = ref.read(authProvider);
    return auth.watchCredential();
  }
}
