import '../../infrastructure/firestore/interface.dart';

class DeleteUserUsecase {
  DeleteUserUsecase({
    required this.uid,
    required this.firestore,
  });

  final String uid;
  final Firestore firestore;

  Future<void> call() async {
    await firestore.deleteUserByUid(uid);
  }
}
