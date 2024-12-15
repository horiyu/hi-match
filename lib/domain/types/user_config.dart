class UserConfig {
  UserConfig({
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
}
