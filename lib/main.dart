import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
final moneyProvider = StateProvider<int>((_) => 10000);
final selectedClubProvider = StateProvider<Club?>((_) => null);

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late List<Fixture> _fixtures;
  bool _isAutoPlay = false;
  late League _league;
  late Stream<bool> _roundStream;
  StreamSubscription<bool>? _roundSubscription;
  int _finishedFixtureNum = 0;
  bool _showFixtures = false;
  bool _showLeagueTable = false;
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

    // for (var fixture in _fixtures) {
    //   fixture.gameStream.listen((event) {
    //     if (event) {
    //       for (var players in fixture.home.club.startPlayers) {
    //         players.growAfterPlay();
    //       }
    //       for (var players in fixture.away.club.startPlayers) {
    //         players.growAfterPlay();
    //       }

    //       if (ref.read(selectedClubProvider) != null) {
    //         if (fixture.home.goal == fixture.away.goal) {
    //           ref.read(moneyProvider.notifier).state =
    //               (1.1 * ref.read(moneyProvider.notifier).state).round();
    //         } else if (fixture.home.goal > fixture.away.goal ||
    //             ref.read(selectedClubProvider)!.id ==
    //                 fixture.home.club.id) {
    //           ref.read(moneyProvider.notifier).state =
    //               (1.5 * ref.read(moneyProvider.notifier).state).round();
    //         } else if (fixture.away.goal > fixture.home.goal ||
    //             ref.read(selectedClubProvider)!.id ==
    //                 fixture.away.club.id) {
    //           ref.read(moneyProvider.notifier).state =
    //               (1.5 * ref.read(moneyProvider.notifier).state).round();
    //         }
    //       }
    //     }
    //     setState(() {});
    //   });
    // }
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
      body: Column(
        children: [
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
          // Row(
          //   children: [
          //     ElevatedButton(
          //       onPressed: () async {
          //         _autoPlaying();
          //       },
          //       child: const Text('한 시즌 자동 재생'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           _showFixtures = !_showFixtures;
          //         });
          //       },
          //       child: const Text('경기들 보기'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           _showLeagueTable = !_showLeagueTable;
          //         });
          //       },
          //       child: const Text('순위 보기'),
          //     )
          //   ],
          // ),
          Text('round : ${_league.round}'),
          SizedBox(height: 20),
          Text('MONEY : ${ref.watch(moneyProvider)}'),
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
                      // if (_selectedClubId != null)
                      ...[..._league.seasons[0].rounds..sort((a, b) => a.number - b.number)]
                          .map((round) => round.fixtures)
                          .expand((list) => list)
                          .where((fixture) => fixture.away.club.name == 'Arsenal' || fixture.home.club.name == 'Arsenal')
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

class FixtureInfo extends ConsumerStatefulWidget {
  const FixtureInfo({super.key, required this.fixture, this.showWDL = true});
  final Fixture fixture;
  final bool showWDL;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixtureInfoState();
}

class _FixtureInfoState extends ConsumerState<FixtureInfo> {
  StreamSubscription<bool>? _streamSubscription;
  Color? _bgColor;

  @override
  Widget build(BuildContext context) {
    if (_streamSubscription != null) _streamSubscription!.cancel();
    _streamSubscription = widget.fixture.gameStream.listen((event) {
      if (event) {
        for (var players in widget.fixture.home.club.startPlayers) {
          players.growAfterPlay();
        }
        for (var players in widget.fixture.away.club.startPlayers) {
          players.growAfterPlay();
        }

        if (ref.read(selectedClubProvider) != null) {
          if (widget.fixture.home.goal == widget.fixture.away.goal) {
            ref.read(moneyProvider.notifier).state = (1.05 * ref.read(moneyProvider)).round();
            _bgColor = Colors.blue;
          } else if (widget.fixture.home.goal > widget.fixture.away.goal && ref.read(selectedClubProvider)!.id == widget.fixture.home.club.id) {
            ref.read(moneyProvider.notifier).state = (1.1 * ref.read(moneyProvider)).round();
            _bgColor = Colors.green;
          } else if (widget.fixture.away.goal > widget.fixture.home.goal && ref.read(selectedClubProvider)!.id == widget.fixture.away.club.id) {
            ref.read(moneyProvider.notifier).state = (1.1 * ref.read(moneyProvider)).round();
            _bgColor = Colors.green;
          }
        }
      }
      setState(() {});
    });

    return Column(
      children: [
        Text('time:${widget.fixture.playTime}'),
        Container(
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
                        ref.read(selectedClubProvider.notifier).state = widget.fixture.home.club;
                        widget.fixture.gameStart();
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
                        ref.read(selectedClubProvider.notifier).state = widget.fixture.away.club;
                        widget.fixture.gameStart();
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
      ],
    );
  }
}
