// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixture_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FixtureDto _$FixtureDtoFromJson(Map<String, dynamic> json) {
  return _FixtureDto.fromJson(json);
}

/// @nodoc
mixin _$FixtureDto {
  int get id => throw _privateConstructorUsedError;
  int get roundId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FixtureDtoCopyWith<FixtureDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixtureDtoCopyWith<$Res> {
  factory $FixtureDtoCopyWith(
          FixtureDto value, $Res Function(FixtureDto) then) =
      _$FixtureDtoCopyWithImpl<$Res, FixtureDto>;
  @useResult
  $Res call({int id, int roundId});
}

/// @nodoc
class _$FixtureDtoCopyWithImpl<$Res, $Val extends FixtureDto>
    implements $FixtureDtoCopyWith<$Res> {
  _$FixtureDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roundId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      roundId: null == roundId
          ? _value.roundId
          : roundId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FixtureDtoImplCopyWith<$Res>
    implements $FixtureDtoCopyWith<$Res> {
  factory _$$FixtureDtoImplCopyWith(
          _$FixtureDtoImpl value, $Res Function(_$FixtureDtoImpl) then) =
      __$$FixtureDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int roundId});
}

/// @nodoc
class __$$FixtureDtoImplCopyWithImpl<$Res>
    extends _$FixtureDtoCopyWithImpl<$Res, _$FixtureDtoImpl>
    implements _$$FixtureDtoImplCopyWith<$Res> {
  __$$FixtureDtoImplCopyWithImpl(
      _$FixtureDtoImpl _value, $Res Function(_$FixtureDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roundId = null,
  }) {
    return _then(_$FixtureDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      roundId: null == roundId
          ? _value.roundId
          : roundId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixtureDtoImpl implements _FixtureDto {
  const _$FixtureDtoImpl({required this.id, required this.roundId});

  factory _$FixtureDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixtureDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int roundId;

  @override
  String toString() {
    return 'FixtureDto(id: $id, roundId: $roundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixtureDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roundId, roundId) || other.roundId == roundId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, roundId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FixtureDtoImplCopyWith<_$FixtureDtoImpl> get copyWith =>
      __$$FixtureDtoImplCopyWithImpl<_$FixtureDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FixtureDtoImplToJson(
      this,
    );
  }
}

abstract class _FixtureDto implements FixtureDto {
  const factory _FixtureDto(
      {required final int id, required final int roundId}) = _$FixtureDtoImpl;

  factory _FixtureDto.fromJson(Map<String, dynamic> json) =
      _$FixtureDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get roundId;
  @override
  @JsonKey(ignore: true)
  _$$FixtureDtoImplCopyWith<_$FixtureDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
