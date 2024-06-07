import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixture_dto.freezed.dart';
part 'fixture_dto.g.dart';

@freezed
class FixtureDto with _$FixtureDto {
  const factory FixtureDto({
    required int id,
    required int roundId,
  }) = _FixtureDto;

  factory FixtureDto.fromJson(Map<String, dynamic> json) => _$FixtureDtoFromJson(json);
}
