import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_slot_dto.freezed.dart';
part 'save_slot_dto.g.dart';

@freezed
class SaveSlotDto with _$SaveSlotDto {
  const factory SaveSlotDto({
    required int id,
    required DateTime date,
    required int selectedLeagueId,
    required int selectedClubId,
  }) = _SaveSlotDto;

  factory SaveSlotDto.fromJson(Map<String, dynamic> json) => _$SaveSlotDtoFromJson(json);
}
