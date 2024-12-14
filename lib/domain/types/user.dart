import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String uid,
    required String handle,
    required String name,
    required String email,
    String? avatar,
    String? bio,
    List<String>? friends,
    required bool isHima,
    List<String>? himaActivityIds,
    required DateTime deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _User;
}
