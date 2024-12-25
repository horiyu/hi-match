import 'package:flutter/material.dart';
import 'package:my_web_app/presentation/theme/colors.dart';
import 'package:my_web_app/presentation/widgets/tag.dart';

class TagButton extends StatelessWidget {
  final String text;
  final double height;
  final VoidCallback onTap;

  const TagButton({
    super.key,
    required this.text,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TagWidget(
        text: text,
        height: height,
      ),
    );
  }
}
