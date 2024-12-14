import 'package:freezed_annotation/freezed_annotation.dart';

part 'hima_activity.freezed.dart';

@freezed
class HimaActivity with _$HimaActivity {
  const factory HimaActivity({
    required String content,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HimaActivity;
}
