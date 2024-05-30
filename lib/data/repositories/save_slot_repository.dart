import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';

class SaveSlotRepository {
  final SaveSlotDataSource dataSource;

  SaveSlotRepository(this.dataSource);

  Future<int> addSaveSlot(Map<String, dynamic> saveSlotData) {
    return dataSource.addSaveSlot(saveSlotData);
  }

  Future<Map<String, dynamic>?> getSaveSlot(int id) {
    return dataSource.getSaveSlot(id);
  }

  Future<int> updateSaveSlot(int id, Map<String, dynamic> saveSlotData) {
    return dataSource.updateSaveSlot(id, saveSlotData);
  }

  Future<int> deleteSaveSlot(int id) {
    return dataSource.deleteSaveSlot(id);
  }

  Future<List<Map<String, dynamic>>> getAllSaveSlots() {
    return dataSource.getAllSaveSlots();
  }
}
