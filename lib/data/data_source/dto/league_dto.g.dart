// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueDtoImpl _$$LeagueDtoImplFromJson(Map<String, dynamic> json) =>
    _$LeagueDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      national: $enumDecode(_$NationalEnumMap, json['national']),
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$$LeagueDtoImplToJson(_$LeagueDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'national': _$NationalEnumMap[instance.national]!,
      'level': instance.level,
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
