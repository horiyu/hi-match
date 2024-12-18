import '../../domain/types/user.dart';

abstract interface class Firestore {
  Future<User> findUserByUid(String uid);

  Future<void> deleteUserByUid(String uid);

  Future<List<User>> getUsers();
}
