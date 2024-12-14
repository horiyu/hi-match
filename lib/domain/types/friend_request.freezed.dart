// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$friendRequest {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;

  /// Create a copy of friendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $friendRequestCopyWith<friendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $friendRequestCopyWith<$Res> {
  factory $friendRequestCopyWith(
          friendRequest value, $Res Function(friendRequest) then) =
      _$friendRequestCopyWithImpl<$Res, friendRequest>;
  @useResult
  $Res call({String from, String to, DateTime sentAt, int status});
}

/// @nodoc
class _$friendRequestCopyWithImpl<$Res, $Val extends friendRequest>
    implements $friendRequestCopyWith<$Res> {
  _$friendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of friendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? sentAt = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$friendRequestImplCopyWith<$Res>
    implements $friendRequestCopyWith<$Res> {
  factory _$$friendRequestImplCopyWith(
          _$friendRequestImpl value, $Res Function(_$friendRequestImpl) then) =
      __$$friendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String from, String to, DateTime sentAt, int status});
}

/// @nodoc
class __$$friendRequestImplCopyWithImpl<$Res>
    extends _$friendRequestCopyWithImpl<$Res, _$friendRequestImpl>
    implements _$$friendRequestImplCopyWith<$Res> {
  __$$friendRequestImplCopyWithImpl(
      _$friendRequestImpl _value, $Res Function(_$friendRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of friendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? sentAt = null,
    Object? status = null,
  }) {
    return _then(_$friendRequestImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$friendRequestImpl implements _friendRequest {
  const _$friendRequestImpl(
      {required this.from,
      required this.to,
      required this.sentAt,
      required this.status});

  @override
  final String from;
  @override
  final String to;
  @override
  final DateTime sentAt;
  @override
  final int status;

  @override
  String toString() {
    return 'friendRequest(from: $from, to: $to, sentAt: $sentAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$friendRequestImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to, sentAt, status);

  /// Create a copy of friendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$friendRequestImplCopyWith<_$friendRequestImpl> get copyWith =>
      __$$friendRequestImplCopyWithImpl<_$friendRequestImpl>(this, _$identity);
}

abstract class _friendRequest implements friendRequest {
  const factory _friendRequest(
      {required final String from,
      required final String to,
      required final DateTime sentAt,
      required final int status}) = _$friendRequestImpl;

  @override
  String get from;
  @override
  String get to;
  @override
  DateTime get sentAt;
  @override
  int get status;

  /// Create a copy of friendRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$friendRequestImplCopyWith<_$friendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
