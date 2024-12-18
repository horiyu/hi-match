import 'package:flutter/material.dart';

import '../../domain/features/count_down.dart';

class CountdownWidget extends StatelessWidget {
  final DateTime deadline;

  CountdownWidget({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final countdown = Countdown(deadline: deadline);
    final countdownString = countdown.getCountdownString();
    final isWarning = countdownString.endsWith('_');

    return Text(
      countdownString.replaceAll('_', ''),
      style: TextStyle(
        color: isWarning ? Colors.red : Colors.black,
      ),
    );
  }
}
