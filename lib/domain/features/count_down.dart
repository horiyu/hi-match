class Countdown {
  Countdown({
    required this.deadline,
  });

  final DateTime deadline;

  String getCountdownString() {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return '期限切れ';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (difference.inHours >= 1) {
      return '残り $hours 時間';
    } else if (difference.inMinutes >= 30) {
      return '残り ${minutes + 1} 分';
    } else {
      return '残り ${minutes + 1} 分';
    }
  }
}
