import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/data/league/epl.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/providers/fixture_provider.dart';
import 'package:soccer_simulator/router/routes.dart';
import 'package:soccer_simulator/utils/color.dart';

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
  bool _showFixtures = true;
  bool _showLeagueTable = false;
  bool _showTopScorerTable = false;
  List<Player> _topScorer = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    // List<Club> clubs = List.generate(18, (idx) {
    //   allFormations.shuffle();
    //   Formation formation = allFormations.first;
    //   return Club(
    //       name: RandomNames(Zone.germany).manName(),
    //       tactics: Tactics(pressDistance: R().getDouble(min: 10, max: 40)),
    //       color: Color.fromRGBO(
    //         Random().nextInt(200) + 55,
    //         Random().nextInt(200) + 55,
    //         Random().nextInt(200) + 55,
    //         1,
    //       ))
    //     ..players = List.generate(
    //         11,
    //         (index) => Player.random(
    //               name: RandomNames(Zone.us).manFullName(),
    //               position: formation.positions[index].position,
    //               backNumber: index,
    //               birthDay: DateTime(2002, 03, 01),
    //               national: National.england,
    //               min: 50 + idx * 3,
    //               max: 70 + idx * 3,
    //               stat: Stat.random(position: formation.positions[index].position, min: 50 + idx * 3, max: 100 + idx * 3),
    //             )
    //               ..isStartingPlayer = true
    //               ..position = formation.positions[index].position
    //               ..startingPoxXY = formation.positions[index].pos);
    // })
    //   ..add(manchesterCity)
    //   ..add(arsenal);
    _league = epl;
    _league.startNewSeason();
    _isAutoPlay = false;
    _initFixture();
  }

  _initFixture() {
    _fixtures = _league.getNextFixtures();
    for (var fixture in _fixtures) {
      fixture.ready();
    }
    _roundStream = StreamGroup.merge(_fixtures.map((e) => e.gameStream).toList());

    _roundSubscription?.cancel();
    _roundSubscription = _roundStream.listen((event) async {
      if (event.isGameEnd && _isAutoPlay) {
        _finishedFixtureNum++;
        if (_finishedFixtureNum == 10) {
          await Future.delayed(Duration(seconds: 0));
          _finishedFixtureNum = 0;
          _league.nextRound();
          _autoPlaying();
        }
      }
      if (mounted) setState(() {});
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
                  onPressed: () {
                    setState(() {
                      _showTopScorerTable = !_showTopScorerTable;
                      if (_showTopScorerTable) _topScorer = _league.getTopScorers(20);
                    });
                  },
                  child: const Text('득점')),
              ElevatedButton(
                onPressed: () async {
                  _autoPlaying();
                },
                child: const Text('자동'),
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
                      if (_showTopScorerTable)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                  )),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 200, child: Text('club')),
                                      SizedBox(width: 100, child: Text('name')),
                                      SizedBox(width: 35, child: Text('bn')),
                                      SizedBox(width: 35, child: Text('ov')),
                                      SizedBox(width: 35, child: Text('goal')),
                                    ],
                                  ),
                                ),
                                ..._topScorer
                                    .map((player) => GestureDetector(
                                          onTap: () {
                                            ref.read(playerProvider.notifier).state = player;
                                            context.push('/players/detail');
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                                            )),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                    width: 200,
                                                    child: Text(_league.clubs
                                                        .where((club) =>
                                                            club.players.where((p) => p.id == player.id).isNotEmpty)
                                                        .first
                                                        .name)),
                                                SizedBox(width: 100, child: Text(player.name)),
                                                SizedBox(width: 35, child: Text('${player.backNumber}')),
                                                SizedBox(width: 35, child: Text('${player.overall}')),
                                                SizedBox(width: 35, child: Text('${player.seasonGoal}')),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      if (_showLeagueTable)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                  )),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 200, child: Text('name')),
                                      SizedBox(width: 35, child: Text('pts')),
                                      SizedBox(width: 35, child: Text('win')),
                                      SizedBox(width: 35, child: Text('draw')),
                                      SizedBox(width: 35, child: Text('lose')),
                                      SizedBox(width: 35, child: Text('gf')),
                                      SizedBox(width: 35, child: Text('ga')),
                                      SizedBox(width: 35, child: Text('gd')),
                                    ],
                                  ),
                                ),
                                ...[..._league.clubs..sort((a, b) => b.pts - a.pts)]
                                    .map((club) => GestureDetector(
                                          onTap: () {
                                            ref.read(playerListProvider.notifier).state = club.startPlayers;
                                            context.push('/players');
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                                            )),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 200, child: Text(club.name)),
                                                SizedBox(width: 35, child: Text('${club.pts}')),
                                                SizedBox(width: 35, child: Text('${club.won}')),
                                                SizedBox(width: 35, child: Text('${club.drawn}')),
                                                SizedBox(width: 35, child: Text('${club.lost}')),
                                                SizedBox(width: 35, child: Text('${club.gf}')),
                                                SizedBox(width: 35, child: Text('${club.ga}')),
                                                SizedBox(width: 35, child: Text('${club.gd}')),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      // ...[..._league.seasons.last.rounds..sort((a, b) => a.number - b.number)]
                      //     .map((round) => round.fixtures)
                      //     .expand((list) => list)
                      //     .where((fixture) => fixture.away.club.name == 'Arsenal' || fixture.home.club.name == 'Arsenal')
                      //     .map((fixture) => FixtureInfo(
                      //           fixture: fixture,
                      //           showWDL: false,
                      //         )),
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
    TextStyle textStyle = TextStyle(
      color: C().colorDifference(Colors.black, club.homeColor) < C().colorDifference(Colors.white, club.homeColor)
          ? Colors.white
          : Colors.black,
    );
    return Container(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${club.name} ',
            style: textStyle,
          ),
          if (showWDL)
            Text(
              '${club.won}/${club.drawn}/${club.lost}',
              style: textStyle,
            )
        ],
      ),
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
      if (event.isGameEnd && mounted) {
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
                          width: constraints.maxWidth *
                              ((widget.fixture.home.goal + 1) /
                                  (widget.fixture.home.goal + widget.fixture.away.goal + 2)),
                          color: widget.fixture.home.club.color.withOpacity(widget.fixture.isGameEnd ? 0.3 : 1),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: constraints.maxWidth *
                              ((widget.fixture.away.goal + 1) /
                                  (widget.fixture.home.goal + widget.fixture.away.goal + 2)),
                          color: widget.fixture.away.club.color.withOpacity(widget.fixture.isGameEnd ? 0.3 : 1),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  color: _bgColor?.withOpacity(0.7),
                ),
                // const Center(child: Text('vs')),
                Row(
                  children: [
                    ClubInfo(
                      club: widget.fixture.home.club,
                      showWDL: widget.showWDL,
                    ),
                    Expanded(child: Container()),
                    Text('${widget.fixture.home.goal}'),
                    const Text('vs'),
                    Text('${widget.fixture.away.goal}'),
                    Expanded(child: Container()),
                    ClubInfo(
                      club: widget.fixture.away.club,
                      showWDL: widget.showWDL,
                    ),
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
