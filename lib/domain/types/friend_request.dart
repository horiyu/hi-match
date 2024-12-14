import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request.freezed.dart';

@freezed
class friendRequest with _$friendRequest {
  const factory friendRequest({
    required String from,
    required String to,
    required DateTime sentAt,
    required int status,
  }) = _friendRequest;
}
