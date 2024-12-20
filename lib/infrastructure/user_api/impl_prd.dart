import 'dart:async';

import '../../domain/types/user.dart';
import 'interface.dart';

class ImplPrd implements UserApi {
  @override
  Future<User?> getUser({required String uid}) async {
    return Future.value(User(
      uid: 'test',
      name: 'テスト',
      email: 'test@example.com',
      handle: 'testHandle',
      isHima: true,
      deadline: DateTime.parse('2023-12-31T23:59:59Z'),
      createdAt: DateTime.parse('2021-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2021-01-01T00:00:00Z'),
      isDeleted: false,
    ));
  }
}
