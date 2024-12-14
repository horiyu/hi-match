import 'package:freezed_annotation/freezed_annotation.dart';

part 'handle.freezed.dart';

@freezed
class Handle with _$Handle {
  const factory Handle({
    required String uid,
  }) = _Handle;
}
