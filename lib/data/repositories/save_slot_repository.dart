import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';

class SaveSlotRepository {
  final SaveSlotDataSource dataSource;

  SaveSlotRepository(this.dataSource);

  Future<int> addSaveSlot({required DateTime date, required int selectedClubId}) {
    return dataSource.addSaveSlot(date: date, selectedClubId: selectedClubId);
  }

  Future<SaveSlotDto?> getSaveSlot({required int id}) {
    return dataSource.getSaveSlot(id: id);
  }

  Future<int> updateSaveSlot({required int id, required DateTime date, required int selectedClubId}) {
    return dataSource.updateSaveSlot(id: id, date: date, selectedClubId: selectedClubId);
  }

  Future<int> deleteSaveSlot({required int id}) {
    return dataSource.deleteSaveSlot(id: id);
  }

  Future<List<SaveSlotDto>> getAllSaveSlots() {
    return dataSource.getAllSaveSlots();
  }
}
