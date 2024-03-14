import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/router/routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

final playerListProvider = StateProvider<List<Player>>((_) => []);
final playerProvider = StateProvider<Player?>((_) => null);

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late Club _club1;
  late Club _club2;
  late List<Fixture> _fixtures;

  List<Player> playerList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    playerList = List.generate(
        20,
        (index) => Player(
              name: RandomNames(Zone.us).manFullName(),
              birthDay: DateTime(2002, 03, 01),
              national: National.england,
              tall: 177,
              stat: PlayerStat.create(),
            ));

    _club1 = Club(
      name: 'arsenal',
    )..players = List.generate(
        20,
        (index) => Player(
              name: RandomNames(Zone.us).manFullName(),
              birthDay: DateTime(2002, 03, 01),
              national: National.england,
              tall: 177,
              stat: PlayerStat.create(),
            ));
    _club2 = Club(
      name: 'manU',
    )..players = List.generate(
        20,
        (index) => Player(
              name: RandomNames(Zone.us).manFullName(),
              birthDay: DateTime(2002, 03, 01),
              national: National.england,
              tall: 177,
              stat: PlayerStat.create(),
            ));
    _fixtures = List.generate(
        5,
        (index) => Fixture(homeClub: _club1, awayClub: _club2)
          ..gameStream.listen((event) {
            setState(() {});
          }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 64),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  init();
                });
              },
              child: const Text('리셋')),
          // ElevatedButton(
          //     onPressed: () {
          //       setState(() {
          //         List.generate(38, (index) {
          //           _player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]);
          //           _player.playGame();
          //         });
          //       });
          //     },
          //     child: const Text('1시즌 시뮬레이션')),
          // ElevatedButton(
          //     onPressed: () {
          //       setState(() {
          //         List.generate(38, (index) => _player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]));
          //       });
          //     },
          //     child: const Text('1시즌 훈련만')),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       for (var player in playerList) {
          //         List.generate(38, (index) {
          //           player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]);
          //           player.playGame();
          //         });
          //       }
          //     });
          //   },
          //   child: const Text('부하테스트'),
          // ),
          ElevatedButton(
            onPressed: () async {
              for (var e in _fixtures) {
                e.gameStart();
              }
            },
            child: const Text('game start'),
          ),
          Container(
            height: 500,
            width: 400,
            child: ListView.builder(
              itemCount: _fixtures.length,
              itemBuilder: (context, index) => Container(
                child: Column(
                  children: [
                    Text('time:${_fixtures[index].playTime}'),
                    Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              height: 30,
                              width:
                                  400 * _fixtures[index].homeTeamBallPercentage,
                              color: Colors.green,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              height: 30,
                              width: 400 *
                                  (1 - _fixtures[index].homeTeamBallPercentage),
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        Container(
                          // color: _fixtures[index].isPlayed ? Colors.blue : Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fixtures[index].homeClub.name),
                              const Text('vs'),
                              Text(_fixtures[index].awayClub.name),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(playerListProvider.notifier).state = _club1.players;
              context.push('/players');
            },
            child: Text(_club1.name),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(playerListProvider.notifier).state = _club2.players;
              context.push('/players');
            },
            child: Text(_club2.name),
          ),
        ],
      ),
    );
  }
}
