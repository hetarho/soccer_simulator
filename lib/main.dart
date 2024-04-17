import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/entities/tactics.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/providers/fixture_provider.dart';
import 'package:soccer_simulator/router/routes.dart';
import 'package:soccer_simulator/utils/random.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // korean
      ],
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
final selectedClubProvider = StateProvider<Club?>((_) => null);

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late List<Fixture> _fixtures;
  bool _isAutoPlay = false;
  late League _league;
  late Stream<FixtureRecord> _roundStream;
  StreamSubscription<FixtureRecord>? _roundSubscription;
  int _finishedFixtureNum = 0;
  bool _showFixtures = false;
  bool _showLeagueTable = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    Formation formation433 = Formation(positions: [
      PositionInFormation(pos: PosXY(25, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(50, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(75, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(25, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(50, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(75, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);

    Formation formation442 = Formation(positions: [
      PositionInFormation(pos: PosXY(35, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(65, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(15, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(40, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(60, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(85, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);

    Formation formation41212 = Formation(positions: [
      PositionInFormation(pos: PosXY(35, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(65, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(50, 75), position: Position.midfielder),
      PositionInFormation(pos: PosXY(35, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(65, 60), position: Position.midfielder),
      PositionInFormation(pos: PosXY(50, 45), position: Position.midfielder),
      PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);
    Formation formation4222 = Formation(positions: [
      PositionInFormation(pos: PosXY(40, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(60, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(15, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(85, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(40, 50), position: Position.midfielder),
      PositionInFormation(pos: PosXY(60, 50), position: Position.midfielder),
      PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);
    Formation formation4141 = Formation(positions: [
      PositionInFormation(pos: PosXY(50, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(15, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(40, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(60, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(85, 70), position: Position.midfielder),
      PositionInFormation(pos: PosXY(50, 50), position: Position.midfielder),
      PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);
    Formation formation352 = Formation(positions: [
      PositionInFormation(pos: PosXY(40, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(60, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(10, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(30, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(50, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(70, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(90, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(30, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(70, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);
    Formation formation532 = Formation(positions: [
      PositionInFormation(pos: PosXY(40, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(60, 90), position: Position.forward),
      PositionInFormation(pos: PosXY(30, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(50, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(70, 65), position: Position.midfielder),
      PositionInFormation(pos: PosXY(10, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(30, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(70, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(90, 30), position: Position.defender),
      PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
    ]);

    List<Formation> formations = [formation433, formation442, formation41212, formation4222, formation4141, formation352];

    List<Club> clubs = List.generate(19, (index) {
      formations.shuffle();
      Formation formation = formations.first;
      return Club(
          name: RandomNames(Zone.germany).manName(),
          tactics: Tactics(pressDistance: R().getDouble(min: 0, max: 70)),
          color: Color.fromRGBO(
            Random().nextInt(200) + 55,
            Random().nextInt(200) + 55,
            Random().nextInt(200) + 55,
            1,
          ))
        ..players = List.generate(
            11,
            (index) => Player.random(
                  name: RandomNames(Zone.us).manFullName(),
                  position: formation.positions[index].position,
                  backNumber: index,
                  birthDay: DateTime(2002, 03, 01),
                  national: National.england,
                  stat: PlayerStat.random(position: formation.positions[index].position, min: 100, max: 200),
                )
                  ..isStartingPlayer = true
                  ..position = formation.positions[index].position
                  ..startingPoxXY = formation.positions[index].pos);
    })
      ..add(Club(name: 'Arsenal', color: Colors.red, tactics: Tactics(pressDistance: 30))
        ..players = List.generate(
            11,
            (index) => Player.random(
                  name: RandomNames(Zone.us).manFullName(),
                  backNumber: index,
                  position: formation433.positions[index].position,
                  birthDay: DateTime(2002, 03, 01),
                  national: National.england,
                  stat: PlayerStat.random(position: formation433.positions[index].position, min: 100, max: 200),
                )
                  ..isStartingPlayer = true
                  ..position = formation433.positions[index].position
                  ..startingPoxXY = formation433.positions[index].pos));
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
      if (event.time.inMinutes >= 90 && _isAutoPlay) {
        _finishedFixtureNum++;
        if (_finishedFixtureNum == 10) {
          _finishedFixtureNum = 0;
          _league.nextRound();
          _autoPlaying();
        }
      }
    });

    if (mounted) setState(() {});
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
      body: Column(
        children: [
          const SizedBox(height: 64),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        init();
                      });
                    }
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
                  if (mounted) setState(() {});
                },
                child: const Text('다음경기로'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _league.startNewSeason();
                  if (mounted) setState(() {});
                },
                child: const Text('다음시즌'),
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
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
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
                      if (_showLeagueTable)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [..._league.clubs..sort((a, b) => b.pts - a.pts)]
                                .map((club) => Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(playerListProvider.notifier).state = club.startPlayers;
                                            context.push('/players');
                                          },
                                          child: Text('${club.name}(${club.overall} ${club.attOverall}/${club.midOverall}/${club.defOverall}) - ${club.pts} ${club.won}/${club.drawn}/${club.lost}'),
                                        )
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 8),
                      ...[..._league.seasons.last.rounds..sort((a, b) => a.number - b.number)]
                          .map((round) => round.fixtures)
                          .expand((list) => list)
                          .where((fixture) => fixture.away.club.name == 'Arsenal' || fixture.home.club.name == 'Arsenal')
                          .map((fixture) => FixtureInfo(
                                fixture: fixture,
                                showWDL: false,
                              )),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              ],
            ),
          ),
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
        Text('${club.name} ${club.attOverall}/${club.midOverall}/${club.defOverall}'),
        if (showWDL)
          Row(
            children: [Text('${club.won}/${club.drawn}/${club.lost}')],
          )
      ],
    );
  }
}

class FixtureInfo extends ConsumerStatefulWidget {
  const FixtureInfo({super.key, required this.fixture, this.showWDL = true});
  final Fixture fixture;
  final bool showWDL;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixtureInfoState();
}

class _FixtureInfoState extends ConsumerState<FixtureInfo> {
  StreamSubscription<FixtureRecord>? _streamSubscription;
  Color? _bgColor;

  @override
  Widget build(BuildContext context) {
    if (_streamSubscription != null) _streamSubscription!.cancel();
    _streamSubscription = widget.fixture.gameStream.listen((event) {
      if (widget.fixture.isGameEnd && mounted) {
        for (var players in widget.fixture.home.club.startPlayers) {
          players.gamePlayed();
        }
        for (var players in widget.fixture.away.club.startPlayers) {
          players.gamePlayed();
        }
      }
      if (mounted) setState(() {});
    });

    return Column(
      children: [
        Text('time:${widget.fixture.playTime}'),
        GestureDetector(
          onTap: () {
            ref.read(fixtureProvider.notifier).state = widget.fixture;
            context.push('/fixture');
          },
          child: Container(
            height: widget.showWDL ? 60 : 40,
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
                          width: constraints.maxWidth * ((widget.fixture.home.goal + 1) / (widget.fixture.home.goal + widget.fixture.away.goal + 2)),
                          color: widget.fixture.home.club.color.withOpacity(widget.fixture.isGameEnd ? 0.3 : 1),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: constraints.maxWidth * ((widget.fixture.away.goal + 1) / (widget.fixture.home.goal + widget.fixture.away.goal + 2)),
                          color: widget.fixture.away.club.color.withOpacity(widget.fixture.isGameEnd ? 0.3 : 1),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  color: _bgColor?.withOpacity(0.7),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          // ref.read(selectedClubProvider.notifier).state = widget.fixture.home.club;
                          // widget.fixture.gameStart();
                        },
                        child: ClubInfo(
                          club: widget.fixture.home.club,
                          showWDL: widget.showWDL,
                        )),
                    Text('${widget.fixture.home.goal}'),
                    const Text('vs'),
                    Text('${widget.fixture.away.goal}'),
                    GestureDetector(
                        onTap: () {
                          // ref.read(selectedClubProvider.notifier).state = widget.fixture.away.club;
                          // widget.fixture.gameStart();
                        },
                        child: ClubInfo(
                          club: widget.fixture.away.club,
                          showWDL: widget.showWDL,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Formation {
  final List<PositionInFormation> positions;

  Formation({required this.positions});
}

class PositionInFormation {
  final PosXY pos;
  final Position position;

  PositionInFormation({required this.pos, required this.position});
}
