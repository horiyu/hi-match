import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/types/user.dart';

import 'interface.dart';

class ImplDev implements Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
