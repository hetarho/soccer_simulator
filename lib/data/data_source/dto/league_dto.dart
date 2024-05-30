import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

part 'league_dto.freezed.dart';
part 'league_dto.g.dart';

@freezed
class LeagueDto with _$LeagueDto {
  const factory LeagueDto({
    required int id,
    required String name,
    required National national,
  }) = _LeagueDto;

  factory LeagueDto.fromJson(Map<String, dynamic> json) => _$LeagueDtoFromJson(json);
}
