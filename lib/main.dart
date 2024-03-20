import 'dart:async';
import 'dart:math';

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
  bool _showFixtures = true;
  bool _showLeagueTable = true;
  String? _selectedClubId;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    List<Club> clubs = List.generate(
        19,
        (index) => Club(
            name: RandomNames(Zone.germany).manName(),
            color: Color.fromRGBO(
              Random().nextInt(180) + 75,
              Random().nextInt(180) + 75,
              Random().nextInt(180) + 75,
              1,
            ))
          ..startPlayers = List.generate(
              11,
              (index) => Player(
                    name: RandomNames(Zone.us).manFullName(),
                    birthDay: DateTime(2002, 03, 01),
                    national: National.england,
                    tall: 177,
                    stat: PlayerStat.create(
                      seed: Random().nextInt(50) + 10,
                      potential: Random().nextInt(60) + 30,
                    ),
                  )))
      ..add(Club(name: 'Arsenal', color: Colors.red)
        ..startPlayers = List.generate(
            11,
            (index) => Player(
                  name: RandomNames(Zone.us).manFullName(),
                  birthDay: DateTime(2002, 03, 01),
                  national: National.england,
                  tall: 177,
                  stat: PlayerStat.create(
                    seed: 70,
                    potential: 90,
                  ),
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
                Row(
                  children: [
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
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _autoPlaying();
                      },
                      child: const Text('한 시즌 자동 재생'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFixtures = !_showFixtures;
                        });
                      },
                      child: const Text('경기들 보기'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showLeagueTable = !_showLeagueTable;
                        });
                      },
                      child: const Text('순위 보기'),
                    )
                  ],
                ),
                Text('round : ${_league.round}'),
                if (_showFixtures)
                  Expanded(
                    child: Column(
                      children: _fixtures
                          .map((fixture) => FixtureInfo(
                                fixture: fixture,
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 40),
                if (_showLeagueTable)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [..._league.clubs..sort((a, b) => b.pts - a.pts)]
                          .map((club) => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedClubId = club.id;
                                      });
                                    },
                                    child: Text('${club.name}(${club.overall}) - ${club.pts} ${club.won}/${club.drawn}/${club.lost}'),
                                  )
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                if (_selectedClubId != null)
                  ...[..._league.seasons[0].rounds..sort((a, b) => a.number - b.number)]
                      .map((round) => round.fixtures)
                      .expand((list) => list)
                      .where((fixture) => fixture.awayClub.id == _selectedClubId || fixture.homeClub.id == _selectedClubId)
                      .map((fixture) => FixtureInfo(
                            fixture: fixture,
                            // targetId: _selectedClubId,
                            showWDL: false,
                          )),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClubInfo extends StatelessWidget {
  const ClubInfo({super.key, required this.club, required this.showWDL});
  final Club club;
  final bool showWDL;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(club.name),
            Text(club.attOverall.toString()),
            Text(club.midOverall.toString()),
            Text(club.defOverall.toString()),
          ],
        ),
        if (showWDL)
          Row(
            children: [Text('${club.won}/${club.drawn}/${club.lost}')],
          )
      ],
    );
  }
}

class FixtureInfo extends ConsumerWidget {
  const FixtureInfo({super.key, required this.fixture, this.targetId, this.showWDL = true});
  final Fixture fixture;
  final String? targetId;
  final bool showWDL;

  @override
  Widget build(BuildContext context, ref) {
    Club leftClub = targetId == null ? fixture.homeClub : (fixture.homeClub.id == targetId ? fixture.homeClub : fixture.awayClub);
    Club rightClub = targetId == null ? fixture.awayClub : (fixture.homeClub.id == targetId ? fixture.homeClub : fixture.awayClub);
    int leftGoal = (fixture.homeClub.id == targetId ? fixture.homeTeamGoal : fixture.awayTeamGoal);
    int rightGoal = (fixture.homeClub.id == targetId ? fixture.awayTeamGoal : fixture.homeTeamGoal);

    return Column(
      children: [
        Text('time:${fixture.playTime}'),
        Container(
          height: showWDL ? 50 : 30,
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
                        width: constraints.maxWidth * ((leftGoal + 1) / (leftGoal + rightGoal + 2)),
                        color: leftClub.color,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: constraints.maxWidth * ((rightGoal + 1) / (leftGoal + rightGoal + 2)),
                        color: rightClub.color,
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
                        ref.read(playerListProvider.notifier).state = leftClub.startPlayers;
                        context.push('/players');
                      },
                      child: ClubInfo(
                        club: leftClub,
                        showWDL: showWDL,
                      )),
                  Text('${fixture.homeTeamGoal}'),
                  const Text('vs'),
                  Text('${fixture.awayTeamGoal}'),
                  GestureDetector(
                      onTap: () {
                        ref.read(playerListProvider.notifier).state = rightClub.startPlayers;
                        context.push('/players');
                      },
                      child: ClubInfo(
                        club: rightClub,
                        showWDL: showWDL,
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
