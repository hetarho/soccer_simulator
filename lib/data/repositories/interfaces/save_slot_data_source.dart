import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';

abstract class SaveSlotDataSource {
  Future<int> addSaveSlot({required DateTime date, required int selectedLeagueId, required int selectedClubId});
  Future<SaveSlotDto?> getSaveSlot({required int id});
  Future<int> updateSaveSlot({required int id, required DateTime date, required int selectedLeagueId, required int selectedClubId});
  Future<int> deleteSaveSlot({required int id});
  Future<List<SaveSlotDto>> getAllSaveSlots();
}
