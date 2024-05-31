import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';
import 'package:soccer_simulator/domain/entities/dbManager/db_manager.dart';

class SaveSlotLocalDataSource implements SaveSlotDataSource {
  final DbManager dbManager;

  SaveSlotLocalDataSource(this.dbManager);

  @override
  Future<int> addSaveSlot({required DateTime date, required int selectedClubId}) async {
    final db = await dbManager.getDatabase();
    final saveSlotData = {
      'date': date.toIso8601String(),
      'selectedClubId': selectedClubId,
    };
    return await db.insert('saveSlot', saveSlotData);
  }

  @override
  Future<SaveSlotDto?> getSaveSlot({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('saveSlot', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return SaveSlotDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateSaveSlot({required int id, required DateTime date, required int selectedClubId}) async {
    final db = await dbManager.getDatabase();
    final saveSlotData = {
      'date': date.toIso8601String(),
      'selectedClubId': selectedClubId,
    };
    return await db.update('saveSlot', saveSlotData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteSaveSlot({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('saveSlot', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SaveSlotDto>> getAllSaveSlots() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('saveSlot');

    return data.map((datum) => SaveSlotDto.fromJson(datum)).toList();
  }
}
