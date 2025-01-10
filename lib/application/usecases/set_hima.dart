import 'package:my_web_app/domain/features/register_hima.dart';

import '../../infrastructure/firestore/interface.dart';

class SetHimaUseCase {
  SetHimaUseCase({
    required this.uid,
    required this.selectedDate,
  });

  final String uid;
  final DateTime selectedDate;

  Future<void> turnOnHima() async {
    print("uid: $uid");
    // firebase.sendEvent(AnalyticsEvent.addNewUser);

    RegisterHima().registerHima(uid, true, selectedDate);


    // listNotifier.add(user);
  }

  Future<void> turnOffHima() async {
    print("uid: $uid");
    // firebase.sendEvent(AnalyticsEvent.addNewUser);

    RegisterHima().registerHima(uid, false, null);

    // listNotifier.add(user);
  }
}
