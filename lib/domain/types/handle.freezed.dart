// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$handle {
  String get uid => throw _privateConstructorUsedError;

  /// Create a copy of handle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $handleCopyWith<handle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $handleCopyWith<$Res> {
  factory $handleCopyWith(handle value, $Res Function(handle) then) =
      _$handleCopyWithImpl<$Res, handle>;
  @useResult
  $Res call({String uid});
}

/// @nodoc
class _$handleCopyWithImpl<$Res, $Val extends handle>
    implements $handleCopyWith<$Res> {
  _$handleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of handle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$handleImplCopyWith<$Res> implements $handleCopyWith<$Res> {
  factory _$$handleImplCopyWith(
          _$handleImpl value, $Res Function(_$handleImpl) then) =
      __$$handleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid});
}

/// @nodoc
class __$$handleImplCopyWithImpl<$Res>
    extends _$handleCopyWithImpl<$Res, _$handleImpl>
    implements _$$handleImplCopyWith<$Res> {
  __$$handleImplCopyWithImpl(
      _$handleImpl _value, $Res Function(_$handleImpl) _then)
      : super(_value, _then);

  /// Create a copy of handle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
  }) {
    return _then(_$handleImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$handleImpl implements _handle {
  const _$handleImpl({required this.uid});

  @override
  final String uid;

  @override
  String toString() {
    return 'handle(uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$handleImpl &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid);

  /// Create a copy of handle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$handleImplCopyWith<_$handleImpl> get copyWith =>
      __$$handleImplCopyWithImpl<_$handleImpl>(this, _$identity);
}

abstract class _handle implements handle {
  const factory _handle({required final String uid}) = _$handleImpl;

  @override
  String get uid;

  /// Create a copy of handle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$handleImplCopyWith<_$handleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
