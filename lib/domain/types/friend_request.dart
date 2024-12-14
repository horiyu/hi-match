import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request.freezed.dart';

@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required String from,
    required String to,
    required DateTime sentAt,
    required int status,
  }) = _FriendRequest;
}
