class HimaChecker {
  HimaChecker({
    required this.isHima,
    required this.deadline,
  });

  final bool isHima;
  final DateTime deadline;

  bool checkHima() {
    final now = DateTime.now();
    return isHima && deadline.isAfter(now);
  }
}
