import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';

class SaveSlot {
  final int id;
  final DateTime date;
  final int selectedLeagueId;
  final int selectedClubId;

  SaveSlot({
    required this.id,
    required this.date,
    required this.selectedLeagueId,
    required this.selectedClubId,
  });

  SaveSlot.fromDto(SaveSlotDto dto)
      : date = dto.date,
        id = dto.id,
        selectedClubId = dto.selectedClubId,
        selectedLeagueId = dto.selectedLeagueId;
}
