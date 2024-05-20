import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/db_manager.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';
import 'package:soccer_simulator/entities/fixture/vo/fixture_record.dart';
import 'package:soccer_simulator/entities/league/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/saveSlot/save_slot.dart';
import 'package:soccer_simulator/providers/providers.dart';
import 'package:soccer_simulator/utils/color.dart';

class LeaguePage extends ConsumerStatefulWidget {
  const LeaguePage({super.key});

  @override
  ConsumerState<LeaguePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<LeaguePage> {
  final Stopwatch _stopwatch = Stopwatch();
  late List<Fixture> _fixtures;
  bool _isAutoPlay = false;
  bool _isAutoPlaySeason = false;
  late League _league;
  late Stream<FixtureRecord> _roundStream;
  StreamSubscription<FixtureRecord>? _roundSubscription;
  int _finishedFixtureNum = 0;
  bool _showFixtures = false;
  bool _showLeagueTable = false;
  bool _showTopScorerTable = false;
  bool _showDetailHistory = false;
  Duration _timer = const Duration(seconds: 0);
  bool _isLoading = false;
  int _currentBeforeSeason = 0;

  @override
  void initState() {
    super.initState();
    _league = ref.read(saveSlotProvider).league;
    _initFixture();
  }

  _showWidget(String str) {
    _showFixtures = false;
    _showLeagueTable = false;
    _showTopScorerTable = false;
    _showDetailHistory = false;
    switch (str) {
      case 'fixtures':
        _showFixtures = true;
        break;
      case 'league_table':
        _showLeagueTable = true;
        break;
      case 'personal_table':
        _showTopScorerTable = true;
        break;
      case 'history':
        _showDetailHistory = true;
        break;
    }
    setState(() {});
  }

  _save() async {
    setState(() {
      _isLoading = true;
    });
    String id = ref.read(saveSlotProvider).id;

    DbManager<SaveSlot> dbManager = DbManager('saveSlot');

    await dbManager.put(id, ref.read(saveSlotProvider));
    setState(() {
      _isLoading = false;
    });
  }

  _initFixture() async {
    _fixtures = _league.getNextFixtures();
    for (var fixture in _fixtures) {
      fixture.ready();
    }
    _roundStream = StreamGroup.merge(_fixtures.map((e) => e.gameStream).toList());

    await _roundSubscription?.cancel();
    _roundSubscription = _roundStream.listen((event) async {
      if (event.isGameEnd && _isAutoPlay) {
        _finishedFixtureNum++;
        if (_finishedFixtureNum == _league.clubs.length / 2) {
          if (_stopwatch.isRunning) {
            _stopwatch.stop();
            print('season${_league.seasons.length} / round:${_league.currentSeason.roundNumber} - ${_stopwatch.elapsed}');
            _stopwatch.reset();
          }
          if (_league.round == (_league.clubs.length - 1) * 2 && _isAutoPlaySeason) {
            _league.endCurrentSeason();
            _league.startNewSeason();
          }
          await Future.delayed(Duration.zero);
          _finishedFixtureNum = 0;
          _league.nextRound();
          _initFixture();
          _startAllFixtures();
        }
      }
      if (mounted) {
        setState(() {
          if (_timer.compareTo(event.time) < 0 || event.time.inMinutes == 0) _timer = event.time;
        });
      }
    });

    if (mounted) setState(() {});
  }

  _startAllFixtures() {
    _stopwatch.start();
    for (var e in _fixtures) {
      if (!e.isGameEnd) e.gameStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            context.push('/');
          },
          child: const Icon(
            Icons.arrow_back,
            size: 16,
          ),
        ),
        actions: [
          _StyedButton(onPressed: _save, child: const Text('save')),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _StyedButton(
                          onPressed: () async {
                            _startAllFixtures();
                          },
                          child: const Icon(Icons.play_arrow),
                        ),
                        _StyedButton(
                          onPressed: () async {
                            if (_league.round == 38) {
                              _league.endCurrentSeason();
                              _league.startNewSeason();
                              _save();
                            } else {
                              _league.nextRound();
                              _initFixture();
                            }
                            if (mounted) setState(() {});
                          },
                          child: const Text('next'),
                        ),
                        _StyedButton(
                          onPressed: () {
                            _showWidget('fixtures');
                          },
                          child: const Text('경기들 보기'),
                        ),
                        _StyedButton(
                            onPressed: () {
                              _showWidget('personal_table');
                            },
                            child: const Text('득점')),
                        _StyedButton(
                          onPressed: () {
                            setState(() {
                              _currentBeforeSeason = _league.seasons.length - 1;
                              _showWidget('league_table');
                            });
                          },
                          child: const Text('순위 보기'),
                        ),
                        _StyedButton(
                          onPressed: () {
                            _showWidget('history');
                          },
                          child: const Text('역사'),
                        ),
                        _StyedButton(
                          onPressed: () {
                            _showWidget('');
                          },
                          child: const Text('close'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('경기 자동'),
                        Switch(
                          value: _isAutoPlay,
                          onChanged: (bool value) {
                            setState(() {
                              _isAutoPlay = value;
                            });
                          },
                        ),
                        const Text('시즌 자동'),
                        Switch(
                          value: _isAutoPlaySeason,
                          onChanged: (bool value) {
                            setState(() {
                              _isAutoPlaySeason = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
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
                          if (_showTopScorerTable) PlayerTableWidget(league: _league),
                          if (_showLeagueTable)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _StyedButton(
                                        onPressed: () {
                                          if (_currentBeforeSeason > 0) {
                                            setState(() {
                                              _currentBeforeSeason--;
                                            });
                                          }
                                        },
                                        child: const Text('prev')),
                                    Text('season:$_currentBeforeSeason'),
                                    _StyedButton(
                                        onPressed: () {
                                          if (_currentBeforeSeason < _league.seasons.length - 1) {
                                            setState(() {
                                              _currentBeforeSeason++;
                                            });
                                          }
                                        },
                                        child: const Text('next')),
                                    _StyedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentBeforeSeason = _league.seasons.length - 1;
                                          });
                                        },
                                        child: const Text('current')),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: LeagueTableWidget(clubs: _currentBeforeSeason == _league.seasons.length - 1 ? _league.table : _league.seasons[_currentBeforeSeason].seasonRecords),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          if (_showDetailHistory)
                            Column(
                              children: [
                                ...[
                                  ...[..._league.clubs]..sort(
                                      (a, b) => a.winner == b.winner ? b.ptsAverage - a.ptsAverage : b.winner - a.winner,
                                    )
                                ].map((club) => Row(
                                      children: [
                                        Text('${club.name}: 우승${club.winner}회 평균 승점:${club.ptsAverage}'),
                                      ],
                                    ))
                              ],
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green[400],
                  color: Colors.black,
                  strokeAlign: 3,
                  strokeWidth: 20,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _StyedButton extends StatelessWidget {
  const _StyedButton({required this.onPressed, required this.child});
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class LeagueTableWidget extends ConsumerWidget {
  const LeagueTableWidget({super.key, required this.clubs});
  final List<Club> clubs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = 1;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.black),
          )),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20, child: Text('')),
              SizedBox(width: 120, child: Text('name')),
              SizedBox(width: 35, child: Text('pts')),
              SizedBox(width: 35, child: Text('win')),
              SizedBox(width: 35, child: Text('draw')),
              SizedBox(width: 35, child: Text('lose')),
              SizedBox(width: 35, child: Text('gf')),
              SizedBox(width: 35, child: Text('ga')),
              SizedBox(width: 35, child: Text('gd')),
              SizedBox(width: 50, child: Text('shoot')),
              SizedBox(width: 50, child: Text('tackle')),
              SizedBox(width: 50, child: Text('pass')),
            ],
          ),
        ),
        ...clubs
            .map((club) => GestureDetector(
                  onTap: () {
                    ref.read(playerListProvider.notifier).state = club.startPlayers;
                    context.push('/players');
                  },
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20, child: Text('${index++}.')),
                        SizedBox(width: 120, child: Text('${club.nickName}(${club.overall})')),
                        SizedBox(width: 35, child: Text('${club.pts}')),
                        SizedBox(width: 35, child: Text('${club.won}')),
                        SizedBox(width: 35, child: Text('${club.drawn}')),
                        SizedBox(width: 35, child: Text('${club.lost}')),
                        SizedBox(width: 35, child: Text('${club.gf}')),
                        SizedBox(width: 35, child: Text('${club.ga}')),
                        SizedBox(width: 35, child: Text('${club.gd}')),
                        SizedBox(width: 50, child: Text((club.seasonShooting / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                        SizedBox(width: 50, child: Text((club.seasonDefSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                        SizedBox(width: 50, child: Text((club.seasonPassSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}

class PlayerTableWidget extends ConsumerStatefulWidget {
  const PlayerTableWidget({super.key, required this.league});
  final League league;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends ConsumerState<PlayerTableWidget> {
  List<Player> _allPlayer = [];

  @override
  void initState() {
    super.initState();
    _allPlayer = widget.league.allPlayer;
  }

  _changeSort(String sortBy) {
    _allPlayer.sort((a, b) => switch (sortBy) {
                  'ov' => b.overall,
                  'assist' => b.seasonAssist,
                  'pass' => b.seasonPassSuccess,
                  'def' => b.seasonDefSuccess,
                  'shoot' => b.seasonShooting,
                  'onTarget' => b.seasonShootOnTarget,
                  'seasonShootAccuracy' => b.seasonShootAccuracy,
                  'passT' => b.seasonPassTry,
                  'passS' => b.seasonPassSuccessPercent,
                  'drib' => b.seasonDribbleSuccess,
                  'inter' => b.seasonIntercept,
                  _ => b.seasonGoal,
                } -
                switch (sortBy) {
                  'ov' => a.overall,
                  'assist' => a.seasonAssist,
                  'pass' => a.seasonPassSuccess,
                  'def' => a.seasonDefSuccess,
                  'shoot' => a.seasonShooting,
                  'onTarget' => a.seasonShootOnTarget,
                  'seasonShootAccuracy' => a.seasonShootAccuracy,
                  'passT' => a.seasonPassTry,
                  'passS' => a.seasonPassSuccessPercent,
                  'drib' => a.seasonDribbleSuccess,
                  'inter' => a.seasonIntercept,
                  _ => a.seasonGoal,
                } >
            0
        ? 1
        : -1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
            child: Container(
              color: const Color.fromARGB(255, 229, 229, 229),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.black),
                    )),
                    // ignore: prefer_const_constructors
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(width: 50, child: Text('club')),
                        SizedBox(width: 65, child: Text('name')),
                        SizedBox(width: 40, child: Text('pos')),
                      ],
                    ),
                  ),
                  ..._allPlayer
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
                                  SizedBox(width: 65, child: Text(player.name, overflow: TextOverflow.ellipsis)),
                                  SizedBox(width: 40, child: Text('${player.position}')),
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('ov');
                                });
                              },
                              child: const SizedBox(width: 50, child: Text('ov'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('goal');
                                });
                              },
                              child: const SizedBox(width: 50, child: Text('goal'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('shoot');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('shoot'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('onTarget');
                                });
                              },
                              child: const SizedBox(width: 80, child: Text('onTarget'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('seasonShootAccuracy');
                                });
                              },
                              child: const SizedBox(width: 60, child: Text('shootA'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('assist');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('assist'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('pass');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('pass'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('passT');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('passT'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('passS');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('passS'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('def');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('def'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('drib');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('drib'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('inter');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('inter'))),
                        ],
                      ),
                    ),
                    ..._allPlayer
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
                                    SizedBox(width: 35, child: Text('${player.overall}')),
                                    SizedBox(width: 50, child: Text('${player.seasonGoal}')),
                                    SizedBox(width: 55, child: Text('${player.seasonShooting}')),
                                    SizedBox(width: 80, child: Text('${player.seasonShootOnTarget}')),
                                    SizedBox(width: 60, child: Text('${player.seasonShootAccuracy}')),
                                    SizedBox(width: 55, child: Text('${player.seasonAssist}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassTry}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassSuccessPercent}')),
                                    SizedBox(width: 55, child: Text('${player.seasonDefSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonDribbleSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonIntercept}')),
                                  ],
                                ),
                              ),
                            ))
                        .toList()
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

class ClubInfo extends ConsumerWidget {
  const ClubInfo({super.key, required this.club, required this.showWDL});
  final Club club;
  final bool showWDL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle textStyle = TextStyle(
      color: C().colorDifference(Colors.black, club.homeColor) < C().colorDifference(Colors.white, club.homeColor) ? Colors.white : Colors.black,
    );
    return SizedBox(
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
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  init() async {
    if (_streamSubscription != null) await _streamSubscription!.cancel();
    _streamSubscription = widget.fixture.gameStream.listen((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('time:${widget.fixture.playTime}'),
        GestureDetector(
          onTap: () {
            ref.read(fixtureProvider.notifier).state = widget.fixture;
            context.push('/fixture');
          },
          child: SizedBox(
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
