import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/formation/formation.dart';
import 'package:soccer_simulator/entities/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/tactics/tactics.dart';
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
  Duration _timer = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    Club arsenal = Club(
      name: 'Arsenal',
      nickName: 'ARS',
      homeColor: Colors.red,
      awayColor: Colors.yellow,
      tactics: Tactics(pressDistance: 30, freeLevel: PlayerFreeLevel.hight),
    )..createStartingMembers(
        min: 60,
        max: 140,
        formation: Formation.create4231(),
      );

    Club manchesterCity = Club(
      name: 'manchesterCity',
      nickName: 'MAC',
      homeColor: Colors.blue[100]!,
      awayColor: Colors.blue[800]!,
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.low),
    )..createStartingMembers(
        min: 85,
        max: 115,
        formation: Formation.create433(),
      );

    Club liverfpool = Club(
      name: 'liverpool',
      nickName: 'LIV',
      homeColor: Colors.red[800]!,
      awayColor: Colors.blue[900]!,
      tactics: Tactics(pressDistance: 35, freeLevel: PlayerFreeLevel.hight),
    )..createStartingMembers(
        min: 70,
        max: 130,
        formation: Formation.create442(),
      );

    Club astonVilla = Club(
      name: 'Aston Villa',
      nickName: 'AV',
      homeColor: const Color.fromARGB(255, 135, 45, 88),
      awayColor: const Color.fromRGBO(140, 188, 229, 1),
      tactics: Tactics(pressDistance: 15, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 60,
        max: 120,
        formation: Formation.create41212(),
      );
    Club tottenham = Club(
      name: 'Tottenham Hotspur',
      nickName: 'TOT',
      homeColor: Colors.white,
      awayColor: const Color.fromRGBO(19, 30, 72, 1),
      tactics: Tactics(pressDistance: 10, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 60,
        max: 120,
        formation: Formation.create433(),
      );
    Club newcastle = Club(
      name: 'Newcastle United',
      nickName: 'NEW',
      homeColor: Colors.black,
      awayColor: Colors.white,
      tactics: Tactics(pressDistance: 35, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 60,
        max: 120,
        formation: Formation.create532(),
      );

    Club manchesterUnited = Club(
      name: 'Manchester United',
      nickName: 'MU',
      homeColor: Colors.red,
      awayColor: Colors.green[200]!,
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 50,
        max: 110,
        formation: Formation.create4222(),
      );

    Club westHam = Club(
      name: 'West Ham United',
      nickName: 'WHU',
      homeColor: const Color.fromARGB(255, 112, 45, 52),
      awayColor: const Color.fromRGBO(179, 110, 70, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 50,
        max: 110,
        formation: Formation.create433(),
      );
    Club chelsea = Club(
      name: 'Chelsea',
      nickName: 'CHE',
      homeColor: const Color.fromARGB(255, 0, 27, 123),
      awayColor: const Color.fromRGBO(80, 70, 85, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 50,
        max: 110,
        formation: Formation.create3241(),
      );

    Club brighton = Club(
      name: 'Brighton And Hov Albion',
      nickName: 'BRH',
      homeColor: const Color.fromARGB(255, 0, 77, 152),
      awayColor: const Color.fromRGBO(80, 255, 255, 255),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create352(),
      );
    Club wolverhampton = Club(
      name: 'Wolverhampton Wanderers',
      nickName: 'WOV',
      homeColor: const Color.fromARGB(255, 250, 174, 40),
      awayColor: const Color.fromRGBO(27, 27, 27, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create352(),
      );

    Club folham = Club(
      name: 'Fulham',
      nickName: 'FUL',
      homeColor: const Color.fromARGB(255, 15, 15, 15),
      awayColor: const Color.fromRGBO(150, 27, 27, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create532(),
      );
    Club bournemouth = Club(
      name: 'Bournemouth',
      nickName: 'BOU',
      homeColor: const Color.fromARGB(255, 200, 6, 20),
      awayColor: const Color.fromRGBO(120, 120, 120, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create4141(),
      );

    Club crystalPalace = Club(
      name: 'Crystal Palace',
      nickName: 'CP',
      homeColor: const Color.fromARGB(255, 15, 45, 115),
      awayColor: const Color.fromRGBO(70, 5, 30, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create41212(),
      );

    Club brentford = Club(
      name: 'Brentford',
      nickName: 'BFD',
      homeColor: const Color.fromARGB(255, 180, 0, 15),
      awayColor: const Color.fromRGBO(70, 25, 25, 25),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 55,
        max: 90,
        formation: Formation.create433(),
      );

    Club everton = Club(
      name: 'Everton',
      nickName: 'EVT',
      homeColor: const Color.fromARGB(255, 0, 60, 140),
      awayColor: const Color.fromRGBO(70, 15, 15, 15),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 45,
        max: 90,
        formation: Formation.create442(),
      );

    Club nottingham = Club(
      name: 'Nottingham Forest',
      nickName: 'NOF',
      homeColor: const Color.fromARGB(255, 230, 35, 55),
      awayColor: const Color.fromRGBO(230, 230, 230, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 45,
        max: 90,
        formation: Formation.create442(),
      );

    Club lutonTown = Club(
      name: 'Luton Town',
      nickName: 'LT',
      homeColor: const Color.fromARGB(255, 130, 130, 110),
      awayColor: const Color.fromRGBO(90, 100, 150, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 45,
        max: 90,
        formation: Formation.create352(),
      );
    Club burnley = Club(
      name: 'Burnley',
      nickName: 'BUN',
      homeColor: const Color.fromARGB(255, 77, 5, 50),
      awayColor: const Color.fromRGBO(90, 100, 150, 1),
      tactics: Tactics(pressDistance: 5, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 45,
        max: 90,
        formation: Formation.create3241(),
      );

    Club sheffield = Club(
      name: 'Sheffield United',
      nickName: 'SHU',
      homeColor: const Color.fromARGB(255, 223, 22, 35),
      awayColor: const Color.fromRGBO(0, 0, 0, 1),
      tactics: Tactics(pressDistance: 25, freeLevel: PlayerFreeLevel.middle),
    )..createStartingMembers(
        min: 45,
        max: 90,
        formation: Formation.create532(),
      );

    List<Club> clubs = [
      arsenal,
      manchesterCity,
      liverfpool,
      astonVilla,
      tottenham,
      newcastle,
      manchesterUnited,
      westHam,
      chelsea,
      brighton,
      wolverhampton,
      folham,
      bournemouth,
      crystalPalace,
      brentford,
      everton,
      nottingham,
      lutonTown,
      burnley,
      sheffield,
    ];

    League epl = League(clubs: clubs);
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
      if (_isAutoPlay) {
        _timer = event.time;
      }
      if (event.isGameEnd && _isAutoPlay) {
        _finishedFixtureNum++;
        if (_finishedFixtureNum == 10) {
          await Future.delayed(const Duration(seconds: 0));
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
          Text('round : ${_league.round} time:${_timer.inMinutes}'),
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
                                      SizedBox(width: 50, child: Text('club')),
                                      SizedBox(width: 90, child: Text('name')),
                                      SizedBox(width: 55, child: Text('number')),
                                      SizedBox(width: 35, child: Text('ov')),
                                      SizedBox(width: 35, child: Text('goal')),
                                      SizedBox(width: 40, child: Text('assist')),
                                    ],
                                  ),
                                ),
                                ..._league.topScorers
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
                                                SizedBox(width: 50, child: Text(player.team?.nickName ?? 'none')),
                                                SizedBox(width: 90, child: Text(player.name)),
                                                SizedBox(width: 55, child: Text('${player.backNumber}')),
                                                SizedBox(width: 35, child: Text('${player.overall}')),
                                                SizedBox(width: 35, child: Text('${player.seasonGoal}')),
                                                SizedBox(width: 40, child: Text('${player.seasonAssist}')),
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
                                ..._league.table
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
                                                SizedBox(width: 200, child: Text('${club.nickName}(${club.overall})')),
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
      color: C().colorDifference(Colors.black, club.homeColor) < C().colorDifference(Colors.white, club.homeColor) ? Colors.white : Colors.black,
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
