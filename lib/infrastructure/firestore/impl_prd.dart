import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_web_app/domain/types/handle.dart';

import '../../domain/features/user_creator.dart';
import '../../domain/features/user_updater.dart';
import '../../domain/types/user.dart';

import 'interface.dart';

class ImplPrd implements Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User> findUserByUid(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      throw Exception('User not found');
    }
    return User(
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      handle: data['handle'] as String,
      isHima: data['isHima'] as bool,
      deadline: (data['deadline'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isDeleted: data['isDeleted'] as bool,
    );
  }

  Future<void> createUser(User user) async {
    final newUser = UserCreater(
      uid: user.uid,
      name: user.name,
      email: user.email,
    ).createNewUser();

    await _firestore.collection('users').doc(newUser.uid).set({
      'uid': newUser.uid,
      'name': newUser.name,
      'email': newUser.email,
      'handle': newUser.handle,
      'isHima': newUser.isHima,
      'deadline': newUser.deadline,
      'createdAt': newUser.createdAt,
      'updatedAt': newUser.updatedAt,
      'isDeleted': newUser.isDeleted,
    });
  }

  Future<void> updateUser(
    User user, {
    String? newName,
    String? newBio,
    String? newAvatar,
    Handle? handle,
    String? newHandle,
  }) async {
    if (newHandle != null && handle == null) {
      throw ArgumentError(
          'Handle must be provided when newHandle is specified');
    }
    var updatedUser = user;
    if (newName != null) {
      updatedUser = UserUpdater().updateName(user, newName);
    }
    if (newBio != null) {
      updatedUser = UserUpdater().updateBio(user, newBio);
    }
    if (newAvatar != null) {
      updatedUser = UserUpdater().updateAvatar(user, newAvatar);
    }
    if (newHandle != null) {
      updatedUser = UserUpdater().updateHandle(user, handle!, newHandle);
    }

    final updateData = <String, dynamic>{
      if (newName != null) 'name': updatedUser.name,
      if (newBio != null) 'bio': updatedUser.bio,
      if (newAvatar != null) 'avatar': updatedUser.avatar,
      if (newHandle != null) 'handle': updatedUser.handle,
      'updatedAt': updatedUser.updatedAt,
    };

    await _firestore
        .collection('users')
        .doc(updatedUser.uid)
        .update(updateData);
  }
}
