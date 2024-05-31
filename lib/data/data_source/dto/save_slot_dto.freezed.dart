// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_slot_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SaveSlotDto _$SaveSlotDtoFromJson(Map<String, dynamic> json) {
  return _SaveSlotDto.fromJson(json);
}

/// @nodoc
mixin _$SaveSlotDto {
  int get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get selectedClubId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SaveSlotDtoCopyWith<SaveSlotDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveSlotDtoCopyWith<$Res> {
  factory $SaveSlotDtoCopyWith(
          SaveSlotDto value, $Res Function(SaveSlotDto) then) =
      _$SaveSlotDtoCopyWithImpl<$Res, SaveSlotDto>;
  @useResult
  $Res call({int id, DateTime date, int selectedClubId});
}

/// @nodoc
class _$SaveSlotDtoCopyWithImpl<$Res, $Val extends SaveSlotDto>
    implements $SaveSlotDtoCopyWith<$Res> {
  _$SaveSlotDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? selectedClubId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedClubId: null == selectedClubId
          ? _value.selectedClubId
          : selectedClubId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaveSlotDtoImplCopyWith<$Res>
    implements $SaveSlotDtoCopyWith<$Res> {
  factory _$$SaveSlotDtoImplCopyWith(
          _$SaveSlotDtoImpl value, $Res Function(_$SaveSlotDtoImpl) then) =
      __$$SaveSlotDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, DateTime date, int selectedClubId});
}

/// @nodoc
class __$$SaveSlotDtoImplCopyWithImpl<$Res>
    extends _$SaveSlotDtoCopyWithImpl<$Res, _$SaveSlotDtoImpl>
    implements _$$SaveSlotDtoImplCopyWith<$Res> {
  __$$SaveSlotDtoImplCopyWithImpl(
      _$SaveSlotDtoImpl _value, $Res Function(_$SaveSlotDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? selectedClubId = null,
  }) {
    return _then(_$SaveSlotDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedClubId: null == selectedClubId
          ? _value.selectedClubId
          : selectedClubId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaveSlotDtoImpl implements _SaveSlotDto {
  const _$SaveSlotDtoImpl(
      {required this.id, required this.date, required this.selectedClubId});

  factory _$SaveSlotDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaveSlotDtoImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime date;
  @override
  final int selectedClubId;

  @override
  String toString() {
    return 'SaveSlotDto(id: $id, date: $date, selectedClubId: $selectedClubId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveSlotDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.selectedClubId, selectedClubId) ||
                other.selectedClubId == selectedClubId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, selectedClubId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveSlotDtoImplCopyWith<_$SaveSlotDtoImpl> get copyWith =>
      __$$SaveSlotDtoImplCopyWithImpl<_$SaveSlotDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaveSlotDtoImplToJson(
      this,
    );
  }
}

abstract class _SaveSlotDto implements SaveSlotDto {
  const factory _SaveSlotDto(
      {required final int id,
      required final DateTime date,
      required final int selectedClubId}) = _$SaveSlotDtoImpl;

  factory _SaveSlotDto.fromJson(Map<String, dynamic> json) =
      _$SaveSlotDtoImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get date;
  @override
  int get selectedClubId;
  @override
  @JsonKey(ignore: true)
  _$$SaveSlotDtoImplCopyWith<_$SaveSlotDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
