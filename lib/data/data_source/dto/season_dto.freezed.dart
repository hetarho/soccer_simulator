// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SeasonDto _$SeasonDtoFromJson(Map<String, dynamic> json) {
  return _SeasonDto.fromJson(json);
}

/// @nodoc
mixin _$SeasonDto {
  int get id => throw _privateConstructorUsedError;
  int get leagueId => throw _privateConstructorUsedError;
  int get roundNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SeasonDtoCopyWith<SeasonDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonDtoCopyWith<$Res> {
  factory $SeasonDtoCopyWith(SeasonDto value, $Res Function(SeasonDto) then) =
      _$SeasonDtoCopyWithImpl<$Res, SeasonDto>;
  @useResult
  $Res call({int id, int leagueId, int roundNumber});
}

/// @nodoc
class _$SeasonDtoCopyWithImpl<$Res, $Val extends SeasonDto>
    implements $SeasonDtoCopyWith<$Res> {
  _$SeasonDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? roundNumber = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeasonDtoImplCopyWith<$Res>
    implements $SeasonDtoCopyWith<$Res> {
  factory _$$SeasonDtoImplCopyWith(
          _$SeasonDtoImpl value, $Res Function(_$SeasonDtoImpl) then) =
      __$$SeasonDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int leagueId, int roundNumber});
}

/// @nodoc
class __$$SeasonDtoImplCopyWithImpl<$Res>
    extends _$SeasonDtoCopyWithImpl<$Res, _$SeasonDtoImpl>
    implements _$$SeasonDtoImplCopyWith<$Res> {
  __$$SeasonDtoImplCopyWithImpl(
      _$SeasonDtoImpl _value, $Res Function(_$SeasonDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? roundNumber = null,
  }) {
    return _then(_$SeasonDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonDtoImpl implements _SeasonDto {
  const _$SeasonDtoImpl(
      {required this.id, required this.leagueId, required this.roundNumber});

  factory _$SeasonDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int leagueId;
  @override
  final int roundNumber;

  @override
  String toString() {
    return 'SeasonDto(id: $id, leagueId: $leagueId, roundNumber: $roundNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, leagueId, roundNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonDtoImplCopyWith<_$SeasonDtoImpl> get copyWith =>
      __$$SeasonDtoImplCopyWithImpl<_$SeasonDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonDtoImplToJson(
      this,
    );
  }
}

abstract class _SeasonDto implements SeasonDto {
  const factory _SeasonDto(
      {required final int id,
      required final int leagueId,
      required final int roundNumber}) = _$SeasonDtoImpl;

  factory _SeasonDto.fromJson(Map<String, dynamic> json) =
      _$SeasonDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get leagueId;
  @override
  int get roundNumber;
  @override
  @JsonKey(ignore: true)
  _$$SeasonDtoImplCopyWith<_$SeasonDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
