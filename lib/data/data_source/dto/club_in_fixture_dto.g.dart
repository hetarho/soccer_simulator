// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_in_fixture_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubInFixtureDtoImpl _$$ClubInFixtureDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ClubInFixtureDtoImpl(
      id: (json['id'] as num).toInt(),
      fixtureId: (json['fixtureId'] as num).toInt(),
      clubId: (json['clubId'] as num).toInt(),
      scoredGoal: (json['scoredGoal'] as num).toInt(),
      hasBallTime: (json['hasBallTime'] as num).toInt(),
      shoot: (json['shoot'] as num).toInt(),
      pass: (json['pass'] as num).toInt(),
      tackle: (json['tackle'] as num).toInt(),
      dribble: (json['dribble'] as num).toInt(),
    );

Map<String, dynamic> _$$ClubInFixtureDtoImplToJson(
        _$ClubInFixtureDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fixtureId': instance.fixtureId,
      'clubId': instance.clubId,
      'scoredGoal': instance.scoredGoal,
      'hasBallTime': instance.hasBallTime,
      'shoot': instance.shoot,
      'pass': instance.pass,
      'tackle': instance.tackle,
      'dribble': instance.dribble,
    };
