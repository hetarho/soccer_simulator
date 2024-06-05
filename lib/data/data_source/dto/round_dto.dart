import 'package:freezed_annotation/freezed_annotation.dart';

part 'round_dto.freezed.dart';
part 'round_dto.g.dart';

@freezed
class RoundDto with _$RoundDto {
  const factory RoundDto({
    required int id,
    required int seasonId,
    required int number,
  }) = _RoundDto;

  factory RoundDto.fromJson(Map<String, dynamic> json) => _$RoundDtoFromJson(json);
}
