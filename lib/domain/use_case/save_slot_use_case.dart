import 'package:soccer_simulator/const/club_seed_data.dart';
import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/data/data_source/dto/save_slot_dto.dart';
import 'package:soccer_simulator/data/repositories/club_repository.dart';
import 'package:soccer_simulator/data/repositories/league_repository.dart';
import 'package:soccer_simulator/data/repositories/save_slot_repository.dart';
import 'package:soccer_simulator/domain/entities/saveSlot/save_slot.dart';
import 'package:soccer_simulator/domain/use_case/_use_case.dart';

class SaveSlotUseCase {
  final SaveSlotRepository repository;

  SaveSlotUseCase(this.repository);

  Future<List<SaveSlot>> getAllSaveSlot() async {
    List<SaveSlotDto> data = await repository.getAllSaveSlots();

    return data.map((dto) => SaveSlot(id: dto.id, date: dto.date, selectedClubId: dto.selectedClubId)).toList();
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

class GetAllSaveSlot extends NoParamUseCase<Future<List<SaveSlot>>> {
  final SaveSlotRepository repository;
  GetAllSaveSlot(this.repository);
  @override
  call() async {
    List<SaveSlotDto> data = await repository.getAllSaveSlots();

    return data.map((dto) => SaveSlot(id: dto.id, date: dto.date, selectedClubId: dto.selectedClubId)).toList();
  }
}

class AddSaveSlot implements UseCase<Future<void>, AddSlotParam> {
  final SaveSlotRepository saveSlotRepository;
  final LeagueRepository leagueRepository;
  final ClubRepository clubRepository;

  AddSaveSlot({required this.saveSlotRepository, required this.leagueRepository, required this.clubRepository});

  @override
  Future<void> call(AddSlotParam param) async {}
}

class AddSlotParam {
  final List<LeagueSeedData> leagueSeedData;
  final List<ClubSeedData> clubSeedData;

  AddSlotParam({required this.leagueSeedData, required this.clubSeedData});
}
