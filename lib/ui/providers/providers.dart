import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/domain/entities/club/club.dart';
import 'package:soccer_simulator/domain/entities/fixture/fixture.dart';
import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/entities/saveSlot/save_slot.dart';
import 'package:soccer_simulator/domain/use_case/save_slot_use_case.dart';
import 'package:soccer_simulator/ui/providers/vo/create_save_slot_vo.dart';

final fixtureProvider = StateProvider<Fixture?>((_) => null);
final playerListProvider = StateProvider<List<Player>>((_) => []);
final playerProvider = StateProvider<Player?>((_) => null);
final selectedClubProvider = StateProvider<Club?>((_) => null);
final saveSlotProvider = StateProvider<SaveSlot?>((_) => null);
final saveSlotUsecaseProvider = StateProvider<SaveSlotUseCase?>((_) => null);

///for ui
final createSaveSlotProvider = StateProvider<CreateSaveSlotVo>((_) => CreateSaveSlotVo());
