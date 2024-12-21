import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/types/user.dart';
import 'interface.dart';

class ImplDev implements UserApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User?> getUser({required String uid}) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return User(
      uid: data['uid'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown',
      email: data['email'] as String? ?? 'Unknown',
      handle: data['handle'] as String? ?? 'Unknown',
      isHima: data['isHima'] as bool? ?? false,
      deadline:
          (data['deadline'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }
}
