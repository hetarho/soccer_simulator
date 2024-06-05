// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubDtoImpl _$$ClubDtoImplFromJson(Map<String, dynamic> json) =>
    _$ClubDtoImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      national: $enumDecode(_$NationalEnumMap, json['national']),
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      homeColor: const ColorJsonConverter()
          .fromJson((json['homeColor'] as num).toInt()),
      awayColor: const ColorJsonConverter()
          .fromJson((json['awayColor'] as num).toInt()),
      tactics: const TacticsJsonConverter()
          .fromJson(json['tactics'] as Map<String, dynamic>),
      winStack: (json['winStack'] as num).toInt(),
      noLoseStack: (json['noLoseStack'] as num).toInt(),
      loseStack: (json['loseStack'] as num).toInt(),
      noWinStack: (json['noWinStack'] as num).toInt(),
    );

Map<String, dynamic> _$$ClubDtoImplToJson(_$ClubDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'national': _$NationalEnumMap[instance.national]!,
      'name': instance.name,
      'nickName': instance.nickName,
      'homeColor': const ColorJsonConverter().toJson(instance.homeColor),
      'awayColor': const ColorJsonConverter().toJson(instance.awayColor),
      'tactics': const TacticsJsonConverter().toJson(instance.tactics),
      'winStack': instance.winStack,
      'noLoseStack': instance.noLoseStack,
      'loseStack': instance.loseStack,
      'noWinStack': instance.noWinStack,
    };

const _$NationalEnumMap = {
  National.france: 'france',
  National.england: 'england',
  National.unitedStates: 'unitedStates',
  National.southKorea: 'southKorea',
  National.belgium: 'belgium',
  National.brazil: 'brazil',
  National.argentina: 'argentina',
  National.chile: 'chile',
  National.mexico: 'mexico',
  National.germany: 'germany',
  National.japan: 'japan',
  National.ukraine: 'ukraine',
  National.italy: 'italy',
  National.netherlands: 'netherlands',
  National.switzerland: 'switzerland',
  National.greece: 'greece',
  National.poland: 'poland',
  National.austria: 'austria',
  National.sweden: 'sweden',
  National.spain: 'spain',
  National.norway: 'norway',
  National.romania: 'romania',
  National.ireland: 'ireland',
  National.croatia: 'croatia',
  National.finland: 'finland',
  National.czechRepublic: 'czechRepublic',
  National.colombia: 'colombia',
  National.portugal: 'portugal',
  National.peru: 'peru',
  National.uruguay: 'uruguay',
  National.ecuador: 'ecuador',
  National.paraguay: 'paraguay',
  National.canada: 'canada',
  National.nigeria: 'nigeria',
  National.ghana: 'ghana',
  National.morocco: 'morocco',
  National.senegal: 'senegal',
  National.ivoryCoast: 'ivoryCoast',
  National.algeria: 'algeria',
  National.cameroon: 'cameroon',
  National.togo: 'togo',
};
