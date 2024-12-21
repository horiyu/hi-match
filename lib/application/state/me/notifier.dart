import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import '../../../infrastructure/user_api/provider.dart';
import '../../credential/provider.dart';

class MeNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final credential = await ref.read(credentialProvider.future);
    if (credential == null) return null;
    final api = ref.read(userApiProvider);
    final me = api.getUser(uid: credential.userID);
    return me;
  }
}
