// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaveSlotDtoImpl _$$SaveSlotDtoImplFromJson(Map<String, dynamic> json) =>
    _$SaveSlotDtoImpl(
      id: (json['id'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      selectedClubId: (json['selectedClubId'] as num).toInt(),
    );

Map<String, dynamic> _$$SaveSlotDtoImplToJson(_$SaveSlotDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'selectedClubId': instance.selectedClubId,
    };
