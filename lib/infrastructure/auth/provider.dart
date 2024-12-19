import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/flavor/provider.dart';
import '../../domain/types/flavor.dart';
import 'impl_dev.dart';
import 'impl_prd.dart';
import 'impl_stg.dart';
import 'interface.dart';

final authProvider = Provider<Auth>((ref) {
  return switch (flavor) {
    Flavor.dev => ImplDev(),
    Flavor.stg => ImplStg(),
    Flavor.prd => ImplPrd(),
  };
});
