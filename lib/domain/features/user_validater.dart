import '../types/user.dart';

class UserValidater {
  UserValidater({
    required this.minNameLength,
    required this.maxNameLength,
    required this.minHandleLength,
    required this.maxHandleLength,
    required this.maxBioLength,
  });

  final int minNameLength;
  final int maxNameLength;

  final int minHandleLength;
  final int maxHandleLength;

  final int maxBioLength;

  bool validateName(User user) {
    return user.name.isNotEmpty &&
        user.name.length >= minNameLength &&
        user.name.length <= maxNameLength;
  }

  bool validateBio(User user) {
    return user.bio != null && user.bio!.length <= maxBioLength;
  }

  bool validateHandle(User user) {
    return user.handle.isNotEmpty &&
        user.handle.length >= minHandleLength &&
        user.handle.length <= maxHandleLength;
  }
}
