import 'dart:async';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _showLeagueTable = true;
  bool _showTopScorerTable = false;
  bool _showDetailHistory = false;
  Duration _timer = const Duration(seconds: 0);
  bool _isLoading = false;
  int _currentBeforeSeason = 0;

  int _selectedBottomNavigationIndex = 1;

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
          await _initFixture();
          _startAllFixtures();
        }
      }
      if (mounted) {
        if (_timer.compareTo(event.time) < 0 || event.time.inMinutes == 0) {
          setState(() {
            _timer = event.time;
          });
        }
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

  bool get _canPlay => _timer.inMinutes == 0;
  bool get _canNext => _timer.inMinutes == 90;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 블러 효과 설정
              child: Container(
                color: Colors.transparent, // 반투명도 설정
              ),
            ),
          ),
          leading: TextButton(
            onPressed: () {
              context.go('/');
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            const Text('auto'),
            SizedBox(
              width: 40,
              child: FittedBox(
                child: Switch(
                  value: _isAutoPlay,
                  onChanged: (bool value) {
                    setState(() {
                      _isAutoPlay = value;
                    });
                  },
                ),
              ),
            ),
            const Text('skip season'),
            SizedBox(
              width: 40,
              child: FittedBox(
                child: Switch(
                  value: _isAutoPlaySeason,
                  onChanged: (bool value) {
                    setState(() {
                      _isAutoPlaySeason = value;
                    });
                  },
                ),
              ),
            ),
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
              icon: Icon(Icons.person),
              label: 'Person ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
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
                SizedBox(height: 120),
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(30, 0),
                                        ),
                                        onPressed: () {
                                          if (_currentBeforeSeason > 0) {
                                            setState(() {
                                              _currentBeforeSeason--;
                                            });
                                          }
                                        },
                                        child: Text(
                                          '<',
                                          style: Theme.of(context).textTheme.bodyLarge!,
                                        ),
                                      ),
                                      Text(
                                        'season:$_currentBeforeSeason',
                                        style: Theme.of(context).textTheme.bodyLarge!,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(30, 0),
                                        ),
                                        onPressed: () {
                                          if (_currentBeforeSeason < _league.seasons.length - 1) {
                                            setState(() {
                                              _currentBeforeSeason++;
                                            });
                                          }
                                        },
                                        child: Text(
                                          '>',
                                          style: Theme.of(context).textTheme.bodyLarge!,
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(30, 0),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _currentBeforeSeason = _league.seasons.length - 1;
                                          });
                                        },
                                        child: Text(
                                          '>>',
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                letterSpacing: -4,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
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
                                  ].map((club) => DefaultTextStyle(
                                        style: Theme.of(context).textTheme.bodyLarge!,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: Text(club.nickName),
                                            ),
                                            SizedBox(
                                              width: 110,
                                              child: Text('winner - ${club.winner}'),
                                            ),
                                            SizedBox(
                                              child: Text('pts - ${club.ptsAverage}'),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 60),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _canPlay ? Colors.blue[900]!.withOpacity(0.7) : Colors.grey.withOpacity(0.3),
                ),
                onPressed: () async {
                  if (_canPlay) _startAllFixtures();
                },
                child: Text(
                  'play',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        letterSpacing: 10.0,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 50,
              width: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _canNext ? Colors.blue[800]!.withOpacity(0.7) : Colors.grey.withOpacity(0.3),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () async {
                  if (!_canNext) return;
                  _timer = Duration.zero;
                  if (_league.round == 38) {
                    _league.endCurrentSeason();
                    _league.startNewSeason();
                    _save();
                    await _league.nextRound();
                    await _initFixture();
                  } else {
                    _league.nextRound();
                    await _initFixture();
                  }
                  if (mounted) setState(() {});
                },
                child: const Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
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
