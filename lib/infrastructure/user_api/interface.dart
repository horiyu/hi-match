import '../../domain/types/user.dart';

abstract interface class UserApi {
  Future<User?> getUser({
    required String uid,
  });
}