import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_web_app/domain/types/handle.dart';

import '../../domain/features/user_creator.dart';
import '../../domain/features/user_updater.dart';
import '../../domain/types/user.dart';

import 'interface.dart';

class ImplStg implements Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final noDate = DateTime(1970, 1, 1);

  @override
  Future<User> findUserByUid(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      throw Exception('User not found');
    }
    return User(
      uid: data['uid'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown',
      email: data['email'] as String? ?? 'Unknown',
      handle: data['handle'] as String? ?? 'Unknown',
      isHima: data['isHima'] as bool? ?? false,
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? noDate,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? noDate,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? noDate,
      isDeleted: data['isDeleted'] as bool? ?? false,
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

  Future<void> deleteUserByUid(String uid,
      {bool physicalDelete = false}) async {
    if (physicalDelete) {
      await _firestore.collection('users').doc(uid).delete();
    } else {
      await _firestore.collection('users').doc(uid).update({
        'isDeleted': true,
      });
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          uid: data['uid'] as String? ?? '',
          name: data['name'] as String? ?? 'Unknown',
          email: data['email'] as String? ?? 'Unknown',
          handle: data['handle'] as String? ?? 'Unknown',
          isHima: data['isHima'] as bool? ?? false,
          deadline: (data['deadline'] as Timestamp?)?.toDate() ?? noDate,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? noDate,
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? noDate,
          isDeleted: data['isDeleted'] as bool? ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}
