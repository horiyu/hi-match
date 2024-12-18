import '../../infrastructure/firestore/interface.dart';

class DeleteUserUsecase {
  DeleteUserUsecase({
    required this.uid,
    required this.firestore,
  });

  final String uid;
  final Firestore firestore;

  Future<void> deleteUser(String id, bool physucalDelete) async {
    // firebase.sendEvent(AnalyticsEvent.deleteMemo);

    final user = await firestore.findUserByUid(id);

    if (physucalDelete) {
      // user.delete();
    } else {
      // user.isDeleted = true;
      // user.save();
    }
  }
}
