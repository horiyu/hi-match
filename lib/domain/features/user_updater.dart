import 'package:my_web_app/domain/types/handle.dart';

import '../types/user.dart';

class UserUpdater {
  User updateName(User user, String newName) {
    return user.copyWith(name: newName);
  }

  User updateBio(User user, String newBio) {
    return user.copyWith(bio: newBio);
  }

  User updateAvatar(User user, String newAvatar) {
    return user.copyWith(avatar: newAvatar);
  }

  Handle _handleUpdater(Handle handle, String uid) {
    return handle.copyWith(uid: uid);
  }

  User updateHandle(User user, Handle handle, String newHandle) {
    _handleUpdater(handle, user.uid);
    return user.copyWith(handle: newHandle);
  }
}
