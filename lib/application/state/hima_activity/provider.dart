import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_web_app/domain/types/hima_activity.dart';

import '../../../domain/types/user.dart';
import 'notifier.dart';

typedef _N = HimaActivityNotifier;

final himaActivityProvider = AsyncNotifierProvider<_N, List<HimaActivity>>(() {
  return _N();
});
