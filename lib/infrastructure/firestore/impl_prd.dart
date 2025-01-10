import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_web_app/domain/types/handle.dart';

import '../../domain/features/hima_activity_creator.dart';
import '../../domain/features/hima_activity_updater.dart';
import '../../domain/features/user_creator.dart';
import '../../domain/features/user_updater.dart';
import '../../domain/types/hima_activity.dart';
import '../../domain/types/user.dart';

import 'interface.dart';

class ImplPrd implements Firestore {
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
      avatar: data['avatar'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      handle: data['handle'] as String? ?? 'Unknown',
      isHima: data['isHima'] as bool? ?? false,
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? noDate,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? noDate,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? noDate,
      isDeleted: data['isDeleted'] as bool? ?? false,
      friends: (data['friends'] as List<dynamic>?)
              ?.map((friend) => friend as String)
              .toList() ??
          [],
      himaActivityIds: (data['himaActivityIds'] as List<dynamic>?)
              ?.map((activityId) => activityId as String)
              .toList() ??
          [],
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
          avatar: data['avatar'] as String? ?? '',
          bio: data['bio'] as String? ?? '',
          handle: data['handle'] as String? ?? 'Unknown',
          isHima: data['isHima'] as bool? ?? false,
          deadline: (data['deadline'] as Timestamp?)?.toDate() ?? noDate,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? noDate,
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? noDate,
          isDeleted: data['isDeleted'] as bool? ?? false,
          friends: (data['friends'] as List<dynamic>?)
                  ?.map((friend) => friend as String)
                  .toList() ??
              [],
          himaActivityIds: (data['himaActivityIds'] as List<dynamic>?)
                  ?.map((activityId) => activityId as String)
                  .toList() ??
              [],
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> addHimaActivity(
      String userId, String newHimaActivityContent) async {
    final newHimaActivity = HimaActivityCreater(
      uid: userId,
      content: newHimaActivityContent,
    ).createNewHimaActivity();

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("himaActivities")
        .add({
      'content': newHimaActivity.content,
      'createdBy': newHimaActivity.createdBy,
      'createdAt': newHimaActivity.createdAt,
      'updatedAt': newHimaActivity.updatedAt,
    });
  }

  @override
  Future<List<HimaActivity>> getHimaActivities(String userId) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("himaActivities")
        .get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return HimaActivity(
        content: data['content'] as String? ?? '',
        createdBy: data['createdBy'] as String? ?? '',
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      );
    }).toList();
  }

  Future<void> deleteHimaActivity(String userId, String activityId) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("himaActivities")
        .doc(activityId)
        .delete();
  }

  Future<void> updateHimaActivity(
      String userId, String activityId, String newHimaActivityContent) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("himaActivities")
        .doc(activityId)
        .get();

    if (!snapshot.exists) {
      throw Exception('HimaActivity not found');
    }

    final data = snapshot.data();
    if (data == null) {
      throw Exception('HimaActivity data is null');
    }

    final existingHimaActivity = HimaActivity(
      content: data['content'] as String? ?? '',
      createdBy: data['createdBy'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
    );

    final updatedHimaActivity = HimaActivityUpdater().updateContent(
      existingHimaActivity,
      newHimaActivityContent,
    );

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("himaActivities")
        .doc(activityId)
        .update({
      'content': updatedHimaActivity.content,
      'updatedAt': updatedHimaActivity.updatedAt,
    });
  }

  Future<void> registerHima(String userId, DateTime deadline) async {
    // final newHimaActivity = HimaActivityCreater(
    //   uid: userId,
    //   content: himaContent,
    // ).createNewHimaActivity();

    await _firestore.collection("users").doc(userId).update({
      'isHima': true,
      'deadline': deadline,
      'updatedAt': DateTime.now(),
    });
  }
}
