// Flutter imports:
import 'package:flutter/material.dart';
import 'package:my_web_app/presentation/theme/colors.dart';
import 'package:my_web_app/presentation/theme/fonts.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // final icon = isLoading
    //     ? const CircularProgressIndicator()
    //     : const FlutterLogo(size: 100);

    return const Scaffold(
      body: Center(
        child: Text('ひマッチ'),
      ),
    );
  }
}
