import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';
import 'package:soccer_simulator/data/repositories/save_slot_repository.dart';
import 'package:soccer_simulator/domain/entities/saveSlot/save_slot.dart';

class SaveSlotUseCase {
  final SaveSlotRepository repository;

  SaveSlotUseCase(this.repository);

  Future<List<SaveSlot>> getAllSaveSlot() async {
    List<SaveSlotDto> data = await repository.getAllSaveSlots();

    return data.map((dto) => SaveSlot.fromDto(dto)).toList();
  }

  Future<int> addSaveSlot({
    required DateTime date,
    required int selectedClubId,
  }) async {
    int id = await repository.addSaveSlot(
      date: date,
      selectedClubId: selectedClubId,
    );

    return id;
  }
}
