// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hima_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HimaActivity {
  String get content => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of HimaActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HimaActivityCopyWith<HimaActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HimaActivityCopyWith<$Res> {
  factory $HimaActivityCopyWith(
          HimaActivity value, $Res Function(HimaActivity) then) =
      _$HimaActivityCopyWithImpl<$Res, HimaActivity>;
  @useResult
  $Res call(
      {String content,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$HimaActivityCopyWithImpl<$Res, $Val extends HimaActivity>
    implements $HimaActivityCopyWith<$Res> {
  _$HimaActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HimaActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HimaActivityImplCopyWith<$Res>
    implements $HimaActivityCopyWith<$Res> {
  factory _$$HimaActivityImplCopyWith(
          _$HimaActivityImpl value, $Res Function(_$HimaActivityImpl) then) =
      __$$HimaActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$HimaActivityImplCopyWithImpl<$Res>
    extends _$HimaActivityCopyWithImpl<$Res, _$HimaActivityImpl>
    implements _$$HimaActivityImplCopyWith<$Res> {
  __$$HimaActivityImplCopyWithImpl(
      _$HimaActivityImpl _value, $Res Function(_$HimaActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of HimaActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$HimaActivityImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HimaActivityImpl implements _HimaActivity {
  const _$HimaActivityImpl(
      {required this.content,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String content;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'HimaActivity(content: $content, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HimaActivityImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, content, createdBy, createdAt, updatedAt);

  /// Create a copy of HimaActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HimaActivityImplCopyWith<_$HimaActivityImpl> get copyWith =>
      __$$HimaActivityImplCopyWithImpl<_$HimaActivityImpl>(this, _$identity);
}

abstract class _HimaActivity implements HimaActivity {
  const factory _HimaActivity(
      {required final String content,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$HimaActivityImpl;

  @override
  String get content;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of HimaActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HimaActivityImplCopyWith<_$HimaActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
