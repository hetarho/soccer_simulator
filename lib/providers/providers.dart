import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/saveSlot/save_slot.dart';

final fixtureProvider = StateProvider<Fixture?>((_) => null);
final playerListProvider = StateProvider<List<Player>>((_) => []);
final playerProvider = StateProvider<Player?>((_) => null);
final selectedClubProvider = StateProvider<Club?>((_) => null);
final saveSlotProvider = StateProvider<SaveSlot>((_) => SaveSlot.empty());
