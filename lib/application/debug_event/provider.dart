import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifier.dart';

typedef _Notifier = DebugEventNotifier;
typedef _State = void;

final debugEventProvider = NotifierProvider<_Notifier, _State>(
  () {
    return _Notifier();
  },
);
