import '../types/hima_activity.dart';

class HimaActivityUpdater {
  HimaActivity updateContent(HimaActivity himaActivity, String newContent) {
    return himaActivity.copyWith(
      content: newContent,
      updatedAt: DateTime.now(),
    );
  }
}
