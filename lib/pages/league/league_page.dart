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
import 'package:soccer_simulator/pages/league/league_table.dart';
import 'package:soccer_simulator/pages/league/personal_table.dart';
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

  int _selectedBottomNavigationIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomNavigationIndex = index;
    });

    switch (index) {
      case 0:
        _showWidget('personal_table');
        break;
      case 1:
        _currentBeforeSeason = _league.seasons.length - 1;
        _showWidget('league_table');
        break;
      case 2:
        _showWidget('fixtures');
        break;
      case 3:
        _showWidget('history');
        break;
    }
  }

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
            await _save();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              context.go('/');
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.push('/setting');
              },
              child: const Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Person ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
          currentIndex: _selectedBottomNavigationIndex,
          onTap: _onItemTapped,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          _startAllFixtures();
                        },
                        child: const Icon(Icons.play_arrow),
                      ),
                      ElevatedButton(
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
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_currentBeforeSeason > 0) {
                                            setState(() {
                                              _currentBeforeSeason--;
                                            });
                                          }
                                        },
                                        child: const Icon(Icons.arrow_left),
                                      ),
                                      Text('season:$_currentBeforeSeason'),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_currentBeforeSeason < _league.seasons.length - 1) {
                                            setState(() {
                                              _currentBeforeSeason++;
                                            });
                                          }
                                        },
                                        child: const Icon(Icons.arrow_right),
                                      ),
                                      ElevatedButton(
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
