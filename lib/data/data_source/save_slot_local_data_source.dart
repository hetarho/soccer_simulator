import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';
import 'package:soccer_simulator/domain/entities/dbManager/db_manager.dart';

class SaveSlotLocalDataSource implements SaveSlotDataSource {
  final DbManager dbManager;

  SaveSlotLocalDataSource(this.dbManager);

  @override
  Future<int> addSaveSlot(Map<String, dynamic> saveSlotData) async {
    final db = await dbManager.getDatabase();
    return await db.insert('saveSlot', saveSlotData);
  }

  @override
  Future<Map<String, dynamic>?> getSaveSlot(int id) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('saveSlot', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  Future<int> updateSaveSlot(int id, Map<String, dynamic> saveSlotData) async {
    final db = await dbManager.getDatabase();
    return await db.update('saveSlot', saveSlotData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteSaveSlot(int id) async {
    final db = await dbManager.getDatabase();
    return await db.delete('saveSlot', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllSaveSlots() async {
    final db = await dbManager.getDatabase();
    return await db.query('saveSlot');
  }
}
