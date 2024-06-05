import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_season_stat_dto.freezed.dart';
part 'club_season_stat_dto.g.dart';

@freezed
class ClubSeasonStatDto with _$ClubSeasonStatDto {
  const factory ClubSeasonStatDto({
    required int id,
    required int seasonId,
    required int clubId,
    required int won,
    required int drawn,
    required int lost,
    required int gf,
    required int ga,
  }) = _ClubSeasonStatDto;

  factory ClubSeasonStatDto.fromJson(Map<String, dynamic> json) => _$ClubSeasonStatDtoFromJson(json);
}
