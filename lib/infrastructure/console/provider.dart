import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'impl_default.dart';
import 'interface.dart';

final consoleProvider = Provider<Console>((ref) {
  return const ImplDefault();
});
