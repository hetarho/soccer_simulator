import 'dart:async';

import 'package:async/async.dart';
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
  bool _isAutoPlay = false;
  late League _league;
  late Stream<bool> _roundStream;
  StreamSubscription<bool>? _roundSubscription;
  int _finishedFixtureNum = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
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
    _isAutoPlay = false;
    _initFixture();
  }

  _initFixture() {
    _fixtures = _league.getNextFixtures();
    _roundStream = StreamGroup.merge(_fixtures.map((e) => e.gameStream).toList());

    _roundSubscription?.cancel();
    _roundSubscription = _roundStream.listen((event) {
      if (event && _isAutoPlay) {
        _finishedFixtureNum++;
        if (_finishedFixtureNum == 10) {
          _finishedFixtureNum = 0;
          _league.nextRound();
          _autoPlaying();
        }
      }
    });

    for (var fixture in _fixtures) {
      fixture.gameStream.listen((event) {
        if (event) {
          for (var players in fixture.homeClub.startPlayers) {
            players.growAfterPlay();
          }
          for (var players in fixture.awayClub.startPlayers) {
            players.growAfterPlay();
          }
        }
        setState(() {});
      });
    }
    setState(() {});
  }

  _startAllFixtures() {
    for (var e in _fixtures) {
      e.gameStart();
    }
  }

  _autoPlaying() {
    _isAutoPlay = true;
    _initFixture();
    _startAllFixtures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
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
                    _league.nextRound();
                    _initFixture();
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
                Expanded(
                  child: Column(
                    children: _fixtures
                        .map(
                          (fixture) => Column(
                            children: [
                              Text('time:${fixture.playTime}'),
                              Container(
                                height: 50,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: constraints.maxWidth * fixture.homeTeamBallPercentage,
                                              color: Colors.green,
                                            ),
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: constraints.maxWidth * (1 - fixture.homeTeamBallPercentage),
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
                                              ref.read(playerListProvider.notifier).state = fixture.homeClub.startPlayers;
                                              context.push('/players');
                                            },
                                            child: Row(
                                              children: [
                                                Text(fixture.homeClub.name),
                                                Text(fixture.homeClub.attOverall.toString()),
                                                Text(fixture.homeClub.midOverall.toString()),
                                                Text(fixture.homeClub.defOverall.toString()),
                                              ],
                                            )),
                                        const Text('vs'),
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(playerListProvider.notifier).state = fixture.awayClub.startPlayers;
                                            context.push('/players');
                                          },
                                          child: Row(
                                            children: [
                                              Text(fixture.awayClub.name),
                                              Text(fixture.awayClub.attOverall.toString()),
                                              Text(fixture.awayClub.midOverall.toString()),
                                              Text(fixture.awayClub.defOverall.toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
