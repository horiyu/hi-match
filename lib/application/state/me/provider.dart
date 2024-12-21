import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import 'notifier.dart';

typedef _N = MeNotifier;

final meProvider = AsyncNotifierProvider<_N, User>(() {
  return _N();
});
