import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/credential/types/credential.dart';
import 'notifier.dart';

typedef _Notifier = CredentialNotifier;
typedef _State = Credential?;

final credentialProvider = StreamNotifierProvider<_Notifier, _State>(
  () {
    return _Notifier();
  },
);
