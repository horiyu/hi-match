import 'package:my_web_app/domain/types/hima_activity.dart';

class HimaActivityValidater {
  HimaActivityValidater({
    required this.minContentLength,
    required this.maxContentLength,
  });

  final int minContentLength;
  final int maxContentLength;

  bool validateName(HimaActivity himaActivity) {
    return himaActivity.content.isNotEmpty &&
        himaActivity.content.length >= minContentLength &&
        himaActivity.content.length <= maxContentLength;
  }
}
