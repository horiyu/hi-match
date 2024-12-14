import 'package:freezed_annotation/freezed_annotation.dart';

part 'hima_activity.freezed.dart';

@freezed
class himaActivity with _$himaActivity {
  const factory himaActivity({
    required String content,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _himaActivity;
}
