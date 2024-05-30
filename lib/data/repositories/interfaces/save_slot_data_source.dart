abstract class SaveSlotDataSource {
  Future<int> addSaveSlot(Map<String, dynamic> saveSlotData);
  Future<Map<String, dynamic>?> getSaveSlot(int id);
  Future<int> updateSaveSlot(int id, Map<String, dynamic> saveSlotData);
  Future<int> deleteSaveSlot(int id);
  Future<List<Map<String, dynamic>>> getAllSaveSlots();
}
