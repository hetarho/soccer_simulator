// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoundDto _$RoundDtoFromJson(Map<String, dynamic> json) {
  return _RoundDto.fromJson(json);
}

/// @nodoc
mixin _$RoundDto {
  int get id => throw _privateConstructorUsedError;
  int get seasonId => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoundDtoCopyWith<RoundDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundDtoCopyWith<$Res> {
  factory $RoundDtoCopyWith(RoundDto value, $Res Function(RoundDto) then) =
      _$RoundDtoCopyWithImpl<$Res, RoundDto>;
  @useResult
  $Res call({int id, int seasonId, int number});
}

/// @nodoc
class _$RoundDtoCopyWithImpl<$Res, $Val extends RoundDto>
    implements $RoundDtoCopyWith<$Res> {
  _$RoundDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? seasonId = null,
    Object? number = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      seasonId: null == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoundDtoImplCopyWith<$Res>
    implements $RoundDtoCopyWith<$Res> {
  factory _$$RoundDtoImplCopyWith(
          _$RoundDtoImpl value, $Res Function(_$RoundDtoImpl) then) =
      __$$RoundDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int seasonId, int number});
}

/// @nodoc
class __$$RoundDtoImplCopyWithImpl<$Res>
    extends _$RoundDtoCopyWithImpl<$Res, _$RoundDtoImpl>
    implements _$$RoundDtoImplCopyWith<$Res> {
  __$$RoundDtoImplCopyWithImpl(
      _$RoundDtoImpl _value, $Res Function(_$RoundDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? seasonId = null,
    Object? number = null,
  }) {
    return _then(_$RoundDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      seasonId: null == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundDtoImpl implements _RoundDto {
  const _$RoundDtoImpl(
      {required this.id, required this.seasonId, required this.number});

  factory _$RoundDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int seasonId;
  @override
  final int number;

  @override
  String toString() {
    return 'RoundDto(id: $id, seasonId: $seasonId, number: $number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.seasonId, seasonId) ||
                other.seasonId == seasonId) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, seasonId, number);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundDtoImplCopyWith<_$RoundDtoImpl> get copyWith =>
      __$$RoundDtoImplCopyWithImpl<_$RoundDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundDtoImplToJson(
      this,
    );
  }
}

abstract class _RoundDto implements RoundDto {
  const factory _RoundDto(
      {required final int id,
      required final int seasonId,
      required final int number}) = _$RoundDtoImpl;

  factory _RoundDto.fromJson(Map<String, dynamic> json) =
      _$RoundDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get seasonId;
  @override
  int get number;
  @override
  @JsonKey(ignore: true)
  _$$RoundDtoImplCopyWith<_$RoundDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
