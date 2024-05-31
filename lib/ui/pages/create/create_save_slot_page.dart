import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';
import 'package:soccer_simulator/ui/providers/vo/create_save_slot_vo.dart';

class CreateSaveSlotPage extends ConsumerStatefulWidget {
  const CreateSaveSlotPage({super.key});
  static String routes = '/createSaveSlot';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePageState();
}

class _CreatePageState extends ConsumerState<CreateSaveSlotPage> {
  @override
  Widget build(BuildContext context) {
    CreateSaveSlotVo createSaveSlotVo = ref.read(createSaveSlotProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('league'),
          Text(createSaveSlotVo.selectedLeagueSeed?.name ?? ''),
          Text('club'),
          Text(createSaveSlotVo.selectedClubSeed?.name ?? ''),
        ],
      ),
    );
  }
}
