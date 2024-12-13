// Flutter imports:
import 'package:flutter/material.dart';
import 'package:my_web_app/presentation/theme/colors.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final icon = isLoading
        ? const CircularProgressIndicator()
        : const FlutterLogo(size: 100);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        title: const Text('スプラッシュ画面'),
      ),
      body: Center(
        child: icon,
      ),
    );
  }
}
