import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import '../../../infrastructure/user_api/provider.dart';
import '../../credential/provider.dart';

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final credential = await ref.read(credentialProvider.future);
    if (credential == null) return null;
    final api = ref.read(userApiProvider);
    final user = api.getUser(uid: credential.userID);
    print('user: $user');
    print(credential.userID);
    return user;
  }
}
