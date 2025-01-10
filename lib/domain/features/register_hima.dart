import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterHima {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerHima(
      String userId, bool isHima, DateTime? deadline) async {
    await _firestore.collection("users").doc(userId).update({
      'isHima': isHima,
      if (deadline != null) 'deadline': deadline,
      'updatedAt': DateTime.now(),
    });
  }
}
