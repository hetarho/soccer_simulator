// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_season_stat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClubSeasonStatDto _$ClubSeasonStatDtoFromJson(Map<String, dynamic> json) {
  return _ClubSeasonStatDto.fromJson(json);
}

/// @nodoc
mixin _$ClubSeasonStatDto {
  int get id => throw _privateConstructorUsedError;
  int get seasonId => throw _privateConstructorUsedError;
  int get clubId => throw _privateConstructorUsedError;
  int get won => throw _privateConstructorUsedError;
  int get drawn => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;
  int get gf => throw _privateConstructorUsedError;
  int get ga => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubSeasonStatDtoCopyWith<ClubSeasonStatDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubSeasonStatDtoCopyWith<$Res> {
  factory $ClubSeasonStatDtoCopyWith(
          ClubSeasonStatDto value, $Res Function(ClubSeasonStatDto) then) =
      _$ClubSeasonStatDtoCopyWithImpl<$Res, ClubSeasonStatDto>;
  @useResult
  $Res call(
      {int id,
      int seasonId,
      int clubId,
      int won,
      int drawn,
      int lost,
      int gf,
      int ga});
}

/// @nodoc
class _$ClubSeasonStatDtoCopyWithImpl<$Res, $Val extends ClubSeasonStatDto>
    implements $ClubSeasonStatDtoCopyWith<$Res> {
  _$ClubSeasonStatDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? seasonId = null,
    Object? clubId = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
    Object? gf = null,
    Object? ga = null,
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
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as int,
      won: null == won
          ? _value.won
          : won // ignore: cast_nullable_to_non_nullable
              as int,
      drawn: null == drawn
          ? _value.drawn
          : drawn // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
      gf: null == gf
          ? _value.gf
          : gf // ignore: cast_nullable_to_non_nullable
              as int,
      ga: null == ga
          ? _value.ga
          : ga // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubSeasonStatDtoImplCopyWith<$Res>
    implements $ClubSeasonStatDtoCopyWith<$Res> {
  factory _$$ClubSeasonStatDtoImplCopyWith(_$ClubSeasonStatDtoImpl value,
          $Res Function(_$ClubSeasonStatDtoImpl) then) =
      __$$ClubSeasonStatDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int seasonId,
      int clubId,
      int won,
      int drawn,
      int lost,
      int gf,
      int ga});
}

/// @nodoc
class __$$ClubSeasonStatDtoImplCopyWithImpl<$Res>
    extends _$ClubSeasonStatDtoCopyWithImpl<$Res, _$ClubSeasonStatDtoImpl>
    implements _$$ClubSeasonStatDtoImplCopyWith<$Res> {
  __$$ClubSeasonStatDtoImplCopyWithImpl(_$ClubSeasonStatDtoImpl _value,
      $Res Function(_$ClubSeasonStatDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? seasonId = null,
    Object? clubId = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
    Object? gf = null,
    Object? ga = null,
  }) {
    return _then(_$ClubSeasonStatDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      seasonId: null == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as int,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as int,
      won: null == won
          ? _value.won
          : won // ignore: cast_nullable_to_non_nullable
              as int,
      drawn: null == drawn
          ? _value.drawn
          : drawn // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
      gf: null == gf
          ? _value.gf
          : gf // ignore: cast_nullable_to_non_nullable
              as int,
      ga: null == ga
          ? _value.ga
          : ga // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubSeasonStatDtoImpl implements _ClubSeasonStatDto {
  const _$ClubSeasonStatDtoImpl(
      {required this.id,
      required this.seasonId,
      required this.clubId,
      required this.won,
      required this.drawn,
      required this.lost,
      required this.gf,
      required this.ga});

  factory _$ClubSeasonStatDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubSeasonStatDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int seasonId;
  @override
  final int clubId;
  @override
  final int won;
  @override
  final int drawn;
  @override
  final int lost;
  @override
  final int gf;
  @override
  final int ga;

  @override
  String toString() {
    return 'ClubSeasonStatDto(id: $id, seasonId: $seasonId, clubId: $clubId, won: $won, drawn: $drawn, lost: $lost, gf: $gf, ga: $ga)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubSeasonStatDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.seasonId, seasonId) ||
                other.seasonId == seasonId) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.drawn, drawn) || other.drawn == drawn) &&
            (identical(other.lost, lost) || other.lost == lost) &&
            (identical(other.gf, gf) || other.gf == gf) &&
            (identical(other.ga, ga) || other.ga == ga));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, seasonId, clubId, won, drawn, lost, gf, ga);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubSeasonStatDtoImplCopyWith<_$ClubSeasonStatDtoImpl> get copyWith =>
      __$$ClubSeasonStatDtoImplCopyWithImpl<_$ClubSeasonStatDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubSeasonStatDtoImplToJson(
      this,
    );
  }
}

abstract class _ClubSeasonStatDto implements ClubSeasonStatDto {
  const factory _ClubSeasonStatDto(
      {required final int id,
      required final int seasonId,
      required final int clubId,
      required final int won,
      required final int drawn,
      required final int lost,
      required final int gf,
      required final int ga}) = _$ClubSeasonStatDtoImpl;

  factory _ClubSeasonStatDto.fromJson(Map<String, dynamic> json) =
      _$ClubSeasonStatDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get seasonId;
  @override
  int get clubId;
  @override
  int get won;
  @override
  int get drawn;
  @override
  int get lost;
  @override
  int get gf;
  @override
  int get ga;
  @override
  @JsonKey(ignore: true)
  _$$ClubSeasonStatDtoImplCopyWith<_$ClubSeasonStatDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
