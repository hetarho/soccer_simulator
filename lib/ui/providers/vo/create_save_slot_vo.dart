// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/const/club_seed_data.dart';
import 'package:soccer_simulator/const/leagues_seed_data.dart';

class CreateSaveSlotVo {
  LeagueSeedData? selectedLeagueSeed;
  ClubSeedData? selectedClubSeed;
  CreateSaveSlotVo({
    this.selectedLeagueSeed,
    this.selectedClubSeed,
  });
}
