import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/types/user.dart';
import 'notifier.dart';

typedef _N = HimaListNotifier;

final himaListProvider = AsyncNotifierProvider<_N, List<User>>(() {
  return _N();
});
