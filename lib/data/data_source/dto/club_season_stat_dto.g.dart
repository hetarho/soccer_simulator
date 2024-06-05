// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_season_stat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubSeasonStatDtoImpl _$$ClubSeasonStatDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ClubSeasonStatDtoImpl(
      id: (json['id'] as num).toInt(),
      seasonId: (json['seasonId'] as num).toInt(),
      clubId: (json['clubId'] as num).toInt(),
      won: (json['won'] as num).toInt(),
      drawn: (json['drawn'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
      gf: (json['gf'] as num).toInt(),
      ga: (json['ga'] as num).toInt(),
    );

Map<String, dynamic> _$$ClubSeasonStatDtoImplToJson(
        _$ClubSeasonStatDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'clubId': instance.clubId,
      'won': instance.won,
      'drawn': instance.drawn,
      'lost': instance.lost,
      'gf': instance.gf,
      'ga': instance.ga,
    };
