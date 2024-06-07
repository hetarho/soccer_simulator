import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/data/data_source/save_slot_local_data_source.dart';
import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';
import 'package:soccer_simulator/data/repositories/save_slot_repository.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';
import 'package:soccer_simulator/ui/providers/vo/create_save_slot_vo.dart';

class CreateSaveSlotPage extends ConsumerStatefulWidget {
  const CreateSaveSlotPage({super.key});
  static String routes = '/createSaveSlot';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePageState();
}

class _CreatePageState extends ConsumerState<CreateSaveSlotPage> {
  _create() async {
    await DbManager.init();

    ///dbManager 객체 생성
    DbManager dbManager = DbManager();

    ///data source 의존성 주입을 통해 객체 생성
    SaveSlotDataSource saveSlotDataSource = SaveSlotLocalDataSource(dbManager);

    /// repository 의존성 주입을 통해 객체 생성
    SaveSlotRepository saveSlotRepository = SaveSlotRepository(saveSlotDataSource);
  }

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
          ElevatedButton(onPressed: _create, child: Text('create')),
        ],
      ),
    );
  }
}
