import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import 'notifier.dart';

typedef _Notifier = UserNotifier;
typedef _State = User?;

final userProvider = AsyncNotifierProvider<_Notifier, _State>(
  () {
    return _Notifier();
  },
);
