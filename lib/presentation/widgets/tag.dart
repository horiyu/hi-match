import 'package:flutter/material.dart';
import 'package:my_web_app/presentation/theme/colors.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final double height;

  const TagWidget({
    super.key,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: BrandColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tag,
              color: BrandColors.grey,
              size: height * 0.5,
            ),
            const SizedBox(width: 4.0),
            Text(
              text,
              style: TextStyle(fontSize: height * 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
