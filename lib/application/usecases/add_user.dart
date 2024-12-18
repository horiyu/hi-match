import 'package:my_web_app/domain/features/user_creator.dart';

import '../../infrastructure/firestore/impl_dev.dart';

/// メモを追加する
class AddUserUseCase {
  AddUserUseCase({
    required this.uid,
    required this.name,
    required this.email,
  });

  final String uid;
  final String name;
  final String email;

  Future<void> addNewUser() async {
    // firebase.sendEvent(AnalyticsEvent.addNewUser);

    final userCreator = UserCreater(uid: uid, name: name, email: email);
    final newUser = userCreator.createNewUser();
    final firestore = ImplDev();
    await firestore.createUser(newUser);

    // listNotifier.add(user);
  }
}
