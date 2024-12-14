import '../types/user.dart';

class UserCreater {
  UserCreater({
    required this.uid,
    required this.name,
  });

  final String uid;
  final String name;

  User createNewUser() {
    return User(
      uid: uid,
      name: name,
      handle: uid,
      isHima: false,
      deadline: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
  }
}
