import '../../domain/types/hima_activity.dart';
import '../../domain/types/user.dart';

abstract interface class Firestore {
  Future<User> findUserByUid(String uid);

  Future<void> deleteUserByUid(String uid);

  Future<List<User>> getUsers();

  Future<List<HimaActivity>> getHimaActivities(String userId);
}
