import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import 'notifier.dart';

typedef _Notifier = MeNotifier;
typedef _State = User?;

final meProvider = AsyncNotifierProvider<_Notifier, _State>(() {
  return _Notifier();
});
