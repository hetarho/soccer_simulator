// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeasonDtoImpl _$$SeasonDtoImplFromJson(Map<String, dynamic> json) =>
    _$SeasonDtoImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      roundNumber: (json['roundNumber'] as num).toInt(),
    );

Map<String, dynamic> _$$SeasonDtoImplToJson(_$SeasonDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'roundNumber': instance.roundNumber,
    };
