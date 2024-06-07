import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_in_fixture_dto.freezed.dart';
part 'club_in_fixture_dto.g.dart';

@freezed
class ClubInFixtureDto with _$ClubInFixtureDto {
  const factory ClubInFixtureDto({
    required int id,
    required int fixtureId,
    required int clubId,
    required bool isHome,
    required int scoredGoal,
    required int hasBallTime,
    required int shoot,
    required int pass,
    required int tackle,
    required int dribble,
  }) = _ClubInFixtureDto;

  factory ClubInFixtureDto.fromJson(Map<String, dynamic> json) => _$ClubInFixtureDtoFromJson(json);
}
