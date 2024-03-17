import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/league.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/national.dart';
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
  late List<Fixture> _fixtures;
  int _round = 0;
  bool _isAutoPlay = false;
  List _fixtureRes = [];
  late League _league;

  @override
  void initState() {
    super.initState();

    List<Club> clubs = List.generate(
        20,
        (index) => Club(name: RandomNames(Zone.us).manName())
          ..startPlayers = List.generate(
              11,
              (index) => Player(
                    name: RandomNames(Zone.us).manFullName(),
                    birthDay: DateTime(2002, 03, 01),
                    national: National.england,
                    tall: 177,
                    stat: PlayerStat.create(),
                  )));
    _league = League(clubs: clubs);
    _league.startNewSeason();
    _league.gameCallback = () {
      setState(() {});
    };
    init();
  }

  init() {
    _round = 0;
    _isAutoPlay = false;
    _fixtureRes = [];

    _fixtures = _league.nextFixtures();
  }

  initFixture() {
    _league.nextRound();
    _fixtures = _league.nextFixtures();
    setState(() {});
  }

  _startAllFixtures() {
    for (var e in _fixtures) {
      e.gameStart();
    }
  }

  _autoPlaying() {
    _isAutoPlay = true;
    initFixture();
    _startAllFixtures();
    _round++;
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
          ElevatedButton(
            onPressed: () async {
              _startAllFixtures();
            },
            child: const Text('game start'),
          ),
          ElevatedButton(
            onPressed: () async {
              initFixture();
              setState(() {});
            },
            child: const Text('다음경기로'),
          ),
          ElevatedButton(
            onPressed: () async {
              _autoPlaying();
            },
            child: const Text('한 시즌 자동 재생'),
          ),
          Text('round : ${_league.round}'),
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: _fixtures.length,
              itemBuilder: (context, index) => Container(
                child: Column(
                  children: [
                    Text('time:${_fixtures[index].playTime}'),
                    Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: constraints.maxWidth *
                                      _fixtures[index].homeTeamBallPercentage,
                                  height: 30,
                                  color: Colors.green,
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: constraints.maxWidth *
                                      (1 -
                                          _fixtures[index]
                                              .homeTeamBallPercentage),
                                  height: 30,
                                  color: Colors.yellow,
                                ),
                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  ref.read(playerListProvider.notifier).state =
                                      _fixtures[index].homeClub.startPlayers;
                                  print(_fixtures[index]
                                      .homeClub
                                      .startPlayers[0]
                                      .stat
                                      .stamina
                                      .toString());
                                  context.push('/players');
                                },
                                child: Row(
                                  children: [
                                    Text(_fixtures[index].homeClub.name),
                                    Text(_fixtures[index]
                                        .homeClub
                                        .attOverall
                                        .toString()),
                                    Text(_fixtures[index]
                                        .homeClub
                                        .midOverall
                                        .toString()),
                                    Text(_fixtures[index]
                                        .homeClub
                                        .defOverall
                                        .toString()),
                                  ],
                                )),
                            const Text('vs'),
                            GestureDetector(
                              onTap: () {
                                ref.read(playerListProvider.notifier).state =
                                    _fixtures[index].awayClub.startPlayers;
                                context.push('/players');
                              },
                              child: Row(
                                children: [
                                  Text(_fixtures[index].awayClub.name),
                                  Text(_fixtures[index]
                                      .awayClub
                                      .attOverall
                                      .toString()),
                                  Text(_fixtures[index]
                                      .awayClub
                                      .midOverall
                                      .toString()),
                                  Text(_fixtures[index]
                                      .awayClub
                                      .defOverall
                                      .toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
