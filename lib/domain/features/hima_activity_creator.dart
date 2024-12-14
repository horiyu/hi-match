import '../types/hima_activity.dart';

class HimaActivityCreater {
  HimaActivityCreater({
    required this.uid,
    required this.content,
  });

  final String uid;
  final String content;

  HimaActivity createNewHimaActivity() {
    return HimaActivity(
      content: content,
      createdBy: uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
