// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoundDtoImpl _$$RoundDtoImplFromJson(Map<String, dynamic> json) =>
    _$RoundDtoImpl(
      id: (json['id'] as num).toInt(),
      seasonId: (json['seasonId'] as num).toInt(),
      number: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$$RoundDtoImplToJson(_$RoundDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'number': instance.number,
    };
