import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/data/data_source/save_slot_local_data_source.dart';
import 'package:soccer_simulator/data/repositories/interfaces/save_slot_data_source.dart';
import 'package:soccer_simulator/data/repositories/save_slot_repository.dart';
import 'package:soccer_simulator/domain/entities/dbManager/db_manager.dart';
import 'package:soccer_simulator/domain/entities/saveSlot/save_slot.dart';
import 'package:soccer_simulator/domain/use_case/save_slot_use_case.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<StartPage> {
  List<SaveSlot> _saveSlot = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    ///데이터베이스 initialize
    await DbManager.init();

    ///dbManager 객체 생성
    DbManager dbManager = DbManager();

    ///data source 의존성 주입을 통해 객체 생성
    SaveSlotDataSource saveSlotDataSource = SaveSlotLocalDataSource(dbManager);

    /// repository 의존성 주입을 통해 객체 생성
    SaveSlotRepository saveSlotRepository = SaveSlotRepository(saveSlotDataSource);

    /// use case 의존성 주입을 통해 객체 생성
    SaveSlotUseCase saveSlotUseCase = SaveSlotUseCase(saveSlotRepository);

    ref.read(saveSlotUsecaseProvider.notifier).state = saveSlotUseCase;

    _saveSlot = await saveSlotUseCase.getAllSaveSlot();

    setState(() {});

    // DbManager<SaveSlot> manager = DbManager('saveSlot');
    // await manager.init();
    // await _refresh();
  }

  _refresh() async {
    SaveSlotUseCase? usecase = ref.read(saveSlotUsecaseProvider);

    if (usecase != null) {
      int res = await usecase.addSaveSlot(
        date: DateTime.now(),
        selectedClubId: 1,
      );
      print(res);
    }

    // DbManager<SaveSlot> manager = DbManager('saveSlot');
    // _saveSlot = manager.getAll().map((e) => SaveSlot.fromJson(e)).toList();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    // League league = League(clubs: clubs);

                    // SaveSlot slot = SaveSlot(date: DateTime.now(), league: league, club: arsenal);

                    // DbManager<SaveSlot> manager = DbManager('saveSlot');

                    // await manager.put(slot.id, slot);

                    // ref.read(saveSlotProvider.notifier).state = slot;

                    if (context.mounted) context.push('/selectLeague');
                  },
                  child: const Text('create slot')),
              ElevatedButton(
                  onPressed: () async {
                    // List<Club> clubs = List.generate(
                    //   20,
                    //   (index) => Club(
                    //     name: 't$index',
                    //     nickName: 't$index',
                    //     homeColor: const Color.fromARGB(255, 0, 60, 140),
                    //     awayColor: const Color.fromRGBO(70, 15, 15, 1),
                    //     tactics: Tactics.normal(),
                    //   )..createStartingMembers(
                    //       min: index < 10 ? 50 : 80,
                    //       max: index < 10 ? 50 : 80,
                    //       formation: Formation.create433(),
                    //     ),
                    // );

                    // League league = League(clubs: clubs);

                    // SaveSlot slot = SaveSlot(date: DateTime.now(), league: league, club: clubs[0]);

                    // DbManager<SaveSlot> manager = DbManager('saveSlot');

                    // await manager.put(slot.id, slot);

                    // ref.read(saveSlotProvider.notifier).state = slot;

                    if (context.mounted) context.push('/league');
                  },
                  child: const Text('create test')),
              ElevatedButton(
                  onPressed: () {
                    _refresh();
                  },
                  child: const Text('refresh')),
              const SizedBox(height: 24),
              ..._saveSlot.map((slot) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(saveSlotProvider.notifier).state = slot;

                                  if (context.mounted) context.push('/league');
                                },
                                child: Text('${slot.selectedClubId} '),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                // DbManager<SaveSlot> manager = DbManager('saveSlot');

                                // await manager.delete(slot.id);
                                // _saveSlot = (manager.getAll()).map((e) => SaveSlot.fromJson(e)).toList();

                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                backgroundColor: Colors.red[400],
                              ),
                              child: const Text('delete', style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
