import 'dart:math';

import '../types/user.dart';

class UserCreater {
  UserCreater({
    required this.uid,
    required this.name,
    required this.email,
  });

  final String uid;
  final String name;
  final String email;

  User createNewUser() {
    return User(
      uid: uid,
      name: name,
      email: email,
      handle: uid,
      isHima: false,
      deadline: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
  }
}
