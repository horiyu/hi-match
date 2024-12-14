import 'package:freezed_annotation/freezed_annotation.dart';

part 'handle.freezed.dart';

@freezed
class handle with _$handle {
  const factory handle({
    required String uid,
  }) = _handle;
}
