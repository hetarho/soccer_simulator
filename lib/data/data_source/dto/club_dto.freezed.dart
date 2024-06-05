// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClubDto _$ClubDtoFromJson(Map<String, dynamic> json) {
  return _ClubDto.fromJson(json);
}

/// @nodoc
mixin _$ClubDto {
  int get id => throw _privateConstructorUsedError;
  int get leagueId => throw _privateConstructorUsedError;
  National get national => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nickName => throw _privateConstructorUsedError;
  @ColorJsonConverter()
  Color get homeColor => throw _privateConstructorUsedError;
  @ColorJsonConverter()
  Color get awayColor => throw _privateConstructorUsedError;
  @TacticsJsonConverter()
  Tactics get tactics => throw _privateConstructorUsedError;
  int get winStack => throw _privateConstructorUsedError;
  int get noLoseStack => throw _privateConstructorUsedError;
  int get loseStack => throw _privateConstructorUsedError;
  int get noWinStack => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubDtoCopyWith<ClubDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubDtoCopyWith<$Res> {
  factory $ClubDtoCopyWith(ClubDto value, $Res Function(ClubDto) then) =
      _$ClubDtoCopyWithImpl<$Res, ClubDto>;
  @useResult
  $Res call(
      {int id,
      int leagueId,
      National national,
      String name,
      String nickName,
      @ColorJsonConverter() Color homeColor,
      @ColorJsonConverter() Color awayColor,
      @TacticsJsonConverter() Tactics tactics,
      int winStack,
      int noLoseStack,
      int loseStack,
      int noWinStack});
}

/// @nodoc
class _$ClubDtoCopyWithImpl<$Res, $Val extends ClubDto>
    implements $ClubDtoCopyWith<$Res> {
  _$ClubDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? national = null,
    Object? name = null,
    Object? nickName = null,
    Object? homeColor = null,
    Object? awayColor = null,
    Object? tactics = null,
    Object? winStack = null,
    Object? noLoseStack = null,
    Object? loseStack = null,
    Object? noWinStack = null,
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
      national: null == national
          ? _value.national
          : national // ignore: cast_nullable_to_non_nullable
              as National,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      homeColor: null == homeColor
          ? _value.homeColor
          : homeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      awayColor: null == awayColor
          ? _value.awayColor
          : awayColor // ignore: cast_nullable_to_non_nullable
              as Color,
      tactics: null == tactics
          ? _value.tactics
          : tactics // ignore: cast_nullable_to_non_nullable
              as Tactics,
      winStack: null == winStack
          ? _value.winStack
          : winStack // ignore: cast_nullable_to_non_nullable
              as int,
      noLoseStack: null == noLoseStack
          ? _value.noLoseStack
          : noLoseStack // ignore: cast_nullable_to_non_nullable
              as int,
      loseStack: null == loseStack
          ? _value.loseStack
          : loseStack // ignore: cast_nullable_to_non_nullable
              as int,
      noWinStack: null == noWinStack
          ? _value.noWinStack
          : noWinStack // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubDtoImplCopyWith<$Res> implements $ClubDtoCopyWith<$Res> {
  factory _$$ClubDtoImplCopyWith(
          _$ClubDtoImpl value, $Res Function(_$ClubDtoImpl) then) =
      __$$ClubDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int leagueId,
      National national,
      String name,
      String nickName,
      @ColorJsonConverter() Color homeColor,
      @ColorJsonConverter() Color awayColor,
      @TacticsJsonConverter() Tactics tactics,
      int winStack,
      int noLoseStack,
      int loseStack,
      int noWinStack});
}

/// @nodoc
class __$$ClubDtoImplCopyWithImpl<$Res>
    extends _$ClubDtoCopyWithImpl<$Res, _$ClubDtoImpl>
    implements _$$ClubDtoImplCopyWith<$Res> {
  __$$ClubDtoImplCopyWithImpl(
      _$ClubDtoImpl _value, $Res Function(_$ClubDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? national = null,
    Object? name = null,
    Object? nickName = null,
    Object? homeColor = null,
    Object? awayColor = null,
    Object? tactics = null,
    Object? winStack = null,
    Object? noLoseStack = null,
    Object? loseStack = null,
    Object? noWinStack = null,
  }) {
    return _then(_$ClubDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      national: null == national
          ? _value.national
          : national // ignore: cast_nullable_to_non_nullable
              as National,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      homeColor: null == homeColor
          ? _value.homeColor
          : homeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      awayColor: null == awayColor
          ? _value.awayColor
          : awayColor // ignore: cast_nullable_to_non_nullable
              as Color,
      tactics: null == tactics
          ? _value.tactics
          : tactics // ignore: cast_nullable_to_non_nullable
              as Tactics,
      winStack: null == winStack
          ? _value.winStack
          : winStack // ignore: cast_nullable_to_non_nullable
              as int,
      noLoseStack: null == noLoseStack
          ? _value.noLoseStack
          : noLoseStack // ignore: cast_nullable_to_non_nullable
              as int,
      loseStack: null == loseStack
          ? _value.loseStack
          : loseStack // ignore: cast_nullable_to_non_nullable
              as int,
      noWinStack: null == noWinStack
          ? _value.noWinStack
          : noWinStack // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubDtoImpl implements _ClubDto {
  const _$ClubDtoImpl(
      {required this.id,
      required this.leagueId,
      required this.national,
      required this.name,
      required this.nickName,
      @ColorJsonConverter() required this.homeColor,
      @ColorJsonConverter() required this.awayColor,
      @TacticsJsonConverter() required this.tactics,
      required this.winStack,
      required this.noLoseStack,
      required this.loseStack,
      required this.noWinStack});

  factory _$ClubDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int leagueId;
  @override
  final National national;
  @override
  final String name;
  @override
  final String nickName;
  @override
  @ColorJsonConverter()
  final Color homeColor;
  @override
  @ColorJsonConverter()
  final Color awayColor;
  @override
  @TacticsJsonConverter()
  final Tactics tactics;
  @override
  final int winStack;
  @override
  final int noLoseStack;
  @override
  final int loseStack;
  @override
  final int noWinStack;

  @override
  String toString() {
    return 'ClubDto(id: $id, leagueId: $leagueId, national: $national, name: $name, nickName: $nickName, homeColor: $homeColor, awayColor: $awayColor, tactics: $tactics, winStack: $winStack, noLoseStack: $noLoseStack, loseStack: $loseStack, noWinStack: $noWinStack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.national, national) ||
                other.national == national) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.homeColor, homeColor) ||
                other.homeColor == homeColor) &&
            (identical(other.awayColor, awayColor) ||
                other.awayColor == awayColor) &&
            (identical(other.tactics, tactics) || other.tactics == tactics) &&
            (identical(other.winStack, winStack) ||
                other.winStack == winStack) &&
            (identical(other.noLoseStack, noLoseStack) ||
                other.noLoseStack == noLoseStack) &&
            (identical(other.loseStack, loseStack) ||
                other.loseStack == loseStack) &&
            (identical(other.noWinStack, noWinStack) ||
                other.noWinStack == noWinStack));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      leagueId,
      national,
      name,
      nickName,
      homeColor,
      awayColor,
      tactics,
      winStack,
      noLoseStack,
      loseStack,
      noWinStack);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubDtoImplCopyWith<_$ClubDtoImpl> get copyWith =>
      __$$ClubDtoImplCopyWithImpl<_$ClubDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubDtoImplToJson(
      this,
    );
  }
}

abstract class _ClubDto implements ClubDto {
  const factory _ClubDto(
      {required final int id,
      required final int leagueId,
      required final National national,
      required final String name,
      required final String nickName,
      @ColorJsonConverter() required final Color homeColor,
      @ColorJsonConverter() required final Color awayColor,
      @TacticsJsonConverter() required final Tactics tactics,
      required final int winStack,
      required final int noLoseStack,
      required final int loseStack,
      required final int noWinStack}) = _$ClubDtoImpl;

  factory _ClubDto.fromJson(Map<String, dynamic> json) = _$ClubDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get leagueId;
  @override
  National get national;
  @override
  String get name;
  @override
  String get nickName;
  @override
  @ColorJsonConverter()
  Color get homeColor;
  @override
  @ColorJsonConverter()
  Color get awayColor;
  @override
  @TacticsJsonConverter()
  Tactics get tactics;
  @override
  int get winStack;
  @override
  int get noLoseStack;
  @override
  int get loseStack;
  @override
  int get noWinStack;
  @override
  @JsonKey(ignore: true)
  _$$ClubDtoImplCopyWith<_$ClubDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
