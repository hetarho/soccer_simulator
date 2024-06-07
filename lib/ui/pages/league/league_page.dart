import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/domain/entities/club/club.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';
import 'package:soccer_simulator/domain/entities/fixture/fixture.dart';
import 'package:soccer_simulator/domain/entities/fixture/vo/fixture_record.dart';
import 'package:soccer_simulator/domain/entities/league/league.dart';
import 'package:soccer_simulator/domain/entities/league/season.dart';
import 'package:soccer_simulator/domain/entities/saveSlot/save_slot.dart';
import 'package:soccer_simulator/ui/pages/league/league_table.dart';
import 'package:soccer_simulator/ui/pages/league/personal_table.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';
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

  final ValueNotifier<Duration> _timer = ValueNotifier<Duration>(const Duration(seconds: 0));
  bool _isLoading = false;
  int _currentBeforeSeason = 0;
  List<Fixture>? _clubFixtures;
  bool _changeFixtureMode = false;
  bool _showTableGraph = false;
  bool _showRankGraph = false;

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
    // _league = ref.read(saveSlotProvider).league;
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
    
    // String id = ref.read(saveSlotProvider).id;

    // DbManager<SaveSlot> dbManager = DbManager('saveSlot');

    // await dbManager.put(id, ref.read(saveSlotProvider));
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
            _currentBeforeSeason = _league.seasons.length - 1;
          }
          await Future.delayed(Duration.zero);
          _finishedFixtureNum = 0;
          _league.nextRound();
          await _initFixture();
          _startAllFixtures();
        }
      }
      if (mounted) {
        if (_timer.value.inMinutes - event.time.inMinutes < 0 || event.time.inMinutes == 0) {
          _timer.value = event.time;
          if (event.time.inMinutes == 0 || event.time.inMinutes == 90) setState(() {});
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

  bool get _canPlay => _timer.value.inMinutes == 0;
  bool get _canNext => _timer.value.inMinutes == 90;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // AppBar의 배경을 투명하게 설정
          elevation: 0,
          scrolledUnderElevation: 0,
          // flexibleSpace: ClipRect(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 블러 효과 설정
          //     child: Container(),
          //   ),
          // ),

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
                ValueListenableBuilder<Duration>(
                  valueListenable: _timer,
                  builder: (context, value, child) {
                    return Text('round : ${_league.round} time:${_timer.value.inMinutes}');
                  },
                ),
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
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _clubFixtures = null;
                                              _changeFixtureMode = false;
                                            });
                                          },
                                          child: const Text('current'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _changeFixtureMode = !_changeFixtureMode;
                                            });
                                          },
                                          child: const Text('select club'),
                                        ),
                                      ],
                                    ),
                                    if (!_changeFixtureMode)
                                      ...(_clubFixtures ?? _fixtures).map(
                                        (fixture) => FixtureInfo(
                                          fixture: fixture,
                                        ),
                                      ),
                                    if (_changeFixtureMode)
                                      Wrap(
                                        children: [
                                          ..._league.clubs.map((club) => Container(
                                                margin: const EdgeInsets.all(4),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: club.homeColor,
                                                    fixedSize: const Size(85, 50),
                                                  ),
                                                  onPressed: () {
                                                    _clubFixtures = _league.currentSeason.rounds
                                                        .map(
                                                          (round) => round.fixtures.firstWhere((fixture) => fixture.home.club.id == club.id || fixture.away.club.id == club.id),
                                                        )
                                                        .toList();
                                                    _changeFixtureMode = false;
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    club.nickName,
                                                    style: TextStyle(color: C().colorDifference(club.homeColor, Colors.white) > 100 ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            if (_showTopScorerTable) PlayerTableWidget(league: _league),
                            if (_showLeagueTable)
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {});
                                            _showTableGraph = !_showTableGraph;
                                          },
                                          child: const Text('show graph')),
                                      SizedBox(
                                        width: 30,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            minimumSize: Size.zero,
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
                                      ),
                                      Text(
                                        'season:$_currentBeforeSeason',
                                        style: Theme.of(context).textTheme.bodyLarge!,
                                      ),
                                      Container(
                                        width: 30,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            minimumSize: const Size(0, 0),
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
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 30,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            minimumSize: const Size(0, 0),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _currentBeforeSeason = _league.seasons.length - 1;
                                            });
                                          },
                                          child: Text(
                                            '>>',
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                  letterSpacing: -2,
                                                ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (_showTableGraph)
                                    SeasonGraphWidget(
                                      snapshots: _league.seasons[_currentBeforeSeason].seasonSnapshots,
                                      clubs: _league.clubs,
                                    ),
                                  if (!_showTableGraph)
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
                            if (_showDetailHistory) ...[
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showRankGraph = !_showRankGraph;
                                    });
                                  },
                                  child: const Text('show graph')),
                              if (_showRankGraph)
                                RankGraphWidget(clubRanks: _league.seasons.sublist(0, max(0, _league.seasons.length - 1)).map((season) => season.seasonRecords).toList(), clubs: [..._league.clubs]),
                              if (!_showRankGraph) HistoryWidget(clubs: [..._league.clubs]),
                            ],
                            const SizedBox(height: 60),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _canPlay ? Colors.red[900]!.withOpacity(0.7) : Colors.grey.withOpacity(0.3),
                ),
                onPressed: () async {
                  if (_canPlay) _startAllFixtures();
                },
                child: Text(
                  'play',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 40,
              width: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _canNext ? Colors.blue[800]!.withOpacity(0.7) : Colors.grey.withOpacity(0.3),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () async {
                  if (!_canNext) return;
                  _timer.value = Duration.zero;
                  if (_league.round == 38) {
                    _league.endCurrentSeason();
                    _league.startNewSeason();
                    _save();
                    _currentBeforeSeason = _league.seasons.length - 1;

                    await _league.nextRound();
                    await _initFixture();
                  } else {
                    _league.nextRound();
                    await _initFixture();
                  }
                  if (mounted) setState(() {});
                },
                child: Text(
                  '>>',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        letterSpacing: -2,
                        color: Colors.white,
                      ),
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

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key, required this.clubs});
  final List<Club> clubs;

  @override
  Widget build(BuildContext context) {
    clubs.sort(
      (a, b) => a.winner == b.winner ? b.ptsAverage - a.ptsAverage : b.winner - a.winner,
    );
    return Column(
      children: [
        ...clubs.map((club) => DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      club.nickName,
                      style: TextStyle(color: C().colorDifference(club.homeColor, Colors.white) > 100 ? club.homeColor : club.awayColor),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Icon(
                      Icons.emoji_events,
                      color: switch (club.winner) {
                        > 20 => Colors.yellow[900],
                        > 15 => Colors.yellow[700],
                        > 10 => Colors.yellow[500],
                        > 5 => Colors.grey[500],
                        > 0 => Colors.grey[300],
                        _ => Colors.black,
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text('${club.winner}'),
                  ),
                  SizedBox(
                    child: Text('lank avg - ${club.lankAverage}'),
                  ),
                  SizedBox(
                    child: Text(' | pts avg - ${club.ptsAverage}'),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class RankGraphWidget extends StatefulWidget {
  const RankGraphWidget({super.key, required this.clubRanks, required this.clubs});
  final List<List<Club>> clubRanks;
  final List<Club> clubs;

  @override
  State<RankGraphWidget> createState() => _RankGraphWidgetState();
}

class _RankGraphWidgetState extends State<RankGraphWidget> {
  String? _selectedClubId;
  List<String> _selectedClubIds = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 100 + widget.clubRanks.length * 40,
        height: 400,
        child: LineChart(
          mainData(),
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 10:
        text = const Text('10', style: style);
        break;
      case 19:
        text = const Text('19', style: style);
        break;
      case 29:
        text = const Text('29', style: style);
        break;
      case 38:
        text = const Text('38', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '1';
        break;
      case 15:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      case 5:
        text = '15';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    if (widget.clubRanks.isEmpty) return const Text('');
    List<Club> lastSnaps = widget.clubRanks.last;
    Club club = lastSnaps[19 - value.round()];

    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      color: club.homeColor,
      // fontSize: _selectedClubId == club.id ? 20 : 15,
      fontSize: _selectedClubIds.contains(club.id) ? 20 : 15,
      shadows: [
        Shadow(
          offset: const Offset(0, 0),
          blurRadius: 0.1,
          color: Colors.black.withOpacity(0.5),
        )
      ],
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedClubIds.contains(club.id)) {
            _selectedClubIds = _selectedClubIds.where((id) => id != club.id).toList();
          } else {
            _selectedClubIds.add(club.id);
          }
        });
      },
      child: Text(club.nickName, style: style, textAlign: TextAlign.center),
    );
  }

  LineChartData mainData() {
    return LineChartData(
        gridData: const FlGridData(
          show: true,
          horizontalInterval: 1,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: rightTitleWidgets,
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 20,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 20,
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  'x: ${touchedSpot.x}\ny: ${touchedSpot.y}',
                  const TextStyle(color: Colors.red),
                );
              }).toList();
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 1,
        maxX: widget.clubRanks.length.toDouble(),
        minY: 0,
        maxY: 19,
        lineBarsData: widget.clubs.map((club) {
          double season = 1;
          return LineChartBarData(
            spots: widget.clubRanks.map((clubs) {
              int rank = clubs.indexWhere((club2) => club2.id == club.id);
              return FlSpot(season++, 19 - rank.toDouble());
            }).toList(),
            isCurved: true,
            color: _selectedClubIds.isEmpty || _selectedClubIds.contains(club.id) ? club.homeColor : Colors.grey[400],
            preventCurveOverShooting: true,
            barWidth: 5,
            curveSmoothness: 0.25,
            isStrokeCapRound: true,
            shadow: const Shadow(),
            dotData: const FlDotData(
              show: false,
            ),
          );
        }).toList());
  }
}

class SeasonGraphWidget extends StatefulWidget {
  const SeasonGraphWidget({super.key, required this.snapshots, required this.clubs});
  final List<List<SeasonSnapShot>> snapshots;
  final List<Club> clubs;

  @override
  State<SeasonGraphWidget> createState() => _SeasonGraphWidgetState();
}

class _SeasonGraphWidgetState extends State<SeasonGraphWidget> {
  String? _selectedClubId;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 100 + widget.snapshots.length * 20,
        height: 400,
        child: LineChart(
          mainData(),
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 10:
        text = const Text('10', style: style);
        break;
      case 19:
        text = const Text('19', style: style);
        break;
      case 29:
        text = const Text('29', style: style);
        break;
      case 38:
        text = const Text('38', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '1';
        break;
      case 15:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      case 5:
        text = '15';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    if (widget.snapshots.isEmpty) return const Text('');
    List<SeasonSnapShot> lastSnaps = widget.snapshots.last;
    Club club = lastSnaps[19 - value.round()].club;

    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      color: club.homeColor,
      fontSize: _selectedClubId == club.id ? 20 : 15,
      shadows: [
        Shadow(
          offset: const Offset(0, 0),
          blurRadius: 0.1,
          color: Colors.black.withOpacity(0.5),
        )
      ],
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedClubId = _selectedClubId == club.id ? null : club.id;
        });
      },
      child: Text(club.nickName, style: style, textAlign: TextAlign.center),
    );
  }

  LineChartData mainData() {
    return LineChartData(
        gridData: const FlGridData(
          show: true,
          horizontalInterval: 1,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: rightTitleWidgets,
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 20,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 20,
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  'x: ${touchedSpot.x}\ny: ${touchedSpot.y}',
                  const TextStyle(color: Colors.red),
                );
              }).toList();
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 1,
        maxX: widget.snapshots.length.toDouble(),
        minY: 0,
        maxY: 19,
        lineBarsData: widget.clubs.map((club) {
          double index = 1;
          return LineChartBarData(
            spots: widget.snapshots.map((snapList) {
              SeasonSnapShot snapshot = snapList.firstWhere((snap) => snap.club.id == club.id);
              return FlSpot(index++, 20 - snapshot.rank.toDouble());
            }).toList(),
            isCurved: true,
            color: _selectedClubId == null || _selectedClubId == club.id ? club.homeColor : Colors.grey[400],
            preventCurveOverShooting: true,
            barWidth: 5,
            curveSmoothness: 0.25,
            isStrokeCapRound: true,
            shadow: const Shadow(),
            dotData: const FlDotData(
              show: false,
            ),
          );
        }).toList());
  }
}
