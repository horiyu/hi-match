import 'package:flutter/material.dart';

class ErrorUnknownPage extends StatelessWidget {
  const ErrorUnknownPage({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final message = error.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('エラー画面'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
