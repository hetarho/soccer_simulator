// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeagueDto _$LeagueDtoFromJson(Map<String, dynamic> json) {
  return _LeagueDto.fromJson(json);
}

/// @nodoc
mixin _$LeagueDto {
  int get id => throw _privateConstructorUsedError;
  int get saveSlotId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  National get national => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeagueDtoCopyWith<LeagueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueDtoCopyWith<$Res> {
  factory $LeagueDtoCopyWith(LeagueDto value, $Res Function(LeagueDto) then) =
      _$LeagueDtoCopyWithImpl<$Res, LeagueDto>;
  @useResult
  $Res call(
      {int id, int saveSlotId, String name, National national, int level});
}

/// @nodoc
class _$LeagueDtoCopyWithImpl<$Res, $Val extends LeagueDto>
    implements $LeagueDtoCopyWith<$Res> {
  _$LeagueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saveSlotId = null,
    Object? name = null,
    Object? national = null,
    Object? level = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      saveSlotId: null == saveSlotId
          ? _value.saveSlotId
          : saveSlotId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      national: null == national
          ? _value.national
          : national // ignore: cast_nullable_to_non_nullable
              as National,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeagueDtoImplCopyWith<$Res>
    implements $LeagueDtoCopyWith<$Res> {
  factory _$$LeagueDtoImplCopyWith(
          _$LeagueDtoImpl value, $Res Function(_$LeagueDtoImpl) then) =
      __$$LeagueDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, int saveSlotId, String name, National national, int level});
}

/// @nodoc
class __$$LeagueDtoImplCopyWithImpl<$Res>
    extends _$LeagueDtoCopyWithImpl<$Res, _$LeagueDtoImpl>
    implements _$$LeagueDtoImplCopyWith<$Res> {
  __$$LeagueDtoImplCopyWithImpl(
      _$LeagueDtoImpl _value, $Res Function(_$LeagueDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saveSlotId = null,
    Object? name = null,
    Object? national = null,
    Object? level = null,
  }) {
    return _then(_$LeagueDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      saveSlotId: null == saveSlotId
          ? _value.saveSlotId
          : saveSlotId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      national: null == national
          ? _value.national
          : national // ignore: cast_nullable_to_non_nullable
              as National,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueDtoImpl implements _LeagueDto {
  const _$LeagueDtoImpl(
      {required this.id,
      required this.saveSlotId,
      required this.name,
      required this.national,
      required this.level});

  factory _$LeagueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int saveSlotId;
  @override
  final String name;
  @override
  final National national;
  @override
  final int level;

  @override
  String toString() {
    return 'LeagueDto(id: $id, saveSlotId: $saveSlotId, name: $name, national: $national, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saveSlotId, saveSlotId) ||
                other.saveSlotId == saveSlotId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.national, national) ||
                other.national == national) &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, saveSlotId, name, national, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueDtoImplCopyWith<_$LeagueDtoImpl> get copyWith =>
      __$$LeagueDtoImplCopyWithImpl<_$LeagueDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueDtoImplToJson(
      this,
    );
  }
}

abstract class _LeagueDto implements LeagueDto {
  const factory _LeagueDto(
      {required final int id,
      required final int saveSlotId,
      required final String name,
      required final National national,
      required final int level}) = _$LeagueDtoImpl;

  factory _LeagueDto.fromJson(Map<String, dynamic> json) =
      _$LeagueDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get saveSlotId;
  @override
  String get name;
  @override
  National get national;
  @override
  int get level;
  @override
  @JsonKey(ignore: true)
  _$$LeagueDtoImplCopyWith<_$LeagueDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
