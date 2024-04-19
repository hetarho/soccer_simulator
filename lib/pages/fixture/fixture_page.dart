import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/providers/fixture_provider.dart';

class FixturePage extends ConsumerStatefulWidget {
  const FixturePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixturePageState();
}

class _FixturePageState extends ConsumerState<FixturePage> {
  bool isFastMode = true;
  bool showModal = false;
  Player? _selectedPlayer;
  List<Player> actingPlayer = [];
  StreamSubscription<PlayerActEvent>? _playerStreamSubscription;
  late Fixture _fixture;
  int _ballAnimationSpeed = 0;

  @override
  void dispose() {
    _fixture.dispose();
    _playerStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fixture = ref.read(fixtureProvider) ?? Fixture.empty();
    _playerStreamSubscription = _fixture.playerStream.listen((event) {
      if (mounted) {
        setState(() {
          _fixture.setBallPos();
        });
      }
    });
    _fixture.isSimulation = false;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.read(fixtureProvider) == null) return Container();
    Fixture fixture = ref.read(fixtureProvider)!;
    List<FixtureRecord> sortedRecord = fixture.records;
    sortedRecord.sort((a, b) => b.time.compareTo(a.time));

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('play time : ${fixture.playTime.toString().substring(0, 10)}'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${fixture.home.goal}'),
                      const SizedBox(width: 4),
                      Text(
                          '${fixture.home.club.name}(${fixture.home.club.overall}/${fixture.home.club.tactics.pressDistance.toStringAsFixed(1)})'),
                      const SizedBox(width: 4),
                      Text('${fixture.homeBallPercent}%'),
                      const SizedBox(width: 16),
                      const Text('vs'),
                      const SizedBox(width: 16),
                      Text('${fixture.awayBallPercent}%'),
                      const SizedBox(width: 4),
                      Text(
                          '${fixture.away.club.name}(${fixture.away.club.overall}/${fixture.away.club.tactics.pressDistance.toStringAsFixed(1)})'),
                      const SizedBox(width: 4),
                      Text('${fixture.away.goal}'),
                    ],
                  ),
                  const Text('shoot / pass / tackle / dribble'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${fixture.home.shoot}'),
                      const SizedBox(width: 4),
                      Text('${fixture.home.pass}'),
                      const SizedBox(width: 4),
                      Text('${fixture.home.tackle}'),
                      const SizedBox(width: 4),
                      Text('${fixture.home.dribble}'),
                      const SizedBox(width: 16),
                      const Text('vs'),
                      const SizedBox(width: 16),
                      Text('${fixture.away.shoot}'),
                      const SizedBox(width: 4),
                      Text('${fixture.away.pass}'),
                      const SizedBox(width: 4),
                      Text('${fixture.away.tackle}'),
                      const SizedBox(width: 4),
                      Text('${fixture.away.dribble}'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green,
                    child: AspectRatio(
                      aspectRatio: 1.6,
                      child: LayoutBuilder(builder: (context, constraints) {
                        final stadiumWidth = constraints.maxWidth;
                        final stadiumHeight = constraints.maxHeight;
                        double playerSize = stadiumWidth / 16;
                        double ballSize = stadiumWidth / 28;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ...fixture.home.club.startPlayers.map((player) {
                              return AnimatedPositioned(
                                duration: Duration(milliseconds: (player.playSpeed.inMilliseconds / 1).round()),
                                curve: Curves.decelerate,
                                top: stadiumHeight * (player.posXY.x) / 100 - (playerSize / 2),
                                left: stadiumWidth * (player.posXY.y) / 200 - (playerSize / 2),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPlayer = player;
                                      showModal = true;
                                    });
                                  },
                                  child: PlayerWidget(
                                    player: player,
                                    playerSize: playerSize,
                                    color: fixture.home.club.color,
                                  ),
                                ),
                              );
                            }),
                            ...fixture.away.club.startPlayers.map((player) {
                              return AnimatedPositioned(
                                duration: Duration(milliseconds: (player.playSpeed.inMilliseconds / 1).round()),
                                curve: Curves.decelerate,
                                top: stadiumHeight - (stadiumHeight * (player.posXY.x) / 100 + (playerSize / 2)),
                                left: stadiumWidth - (stadiumWidth * (player.posXY.y) / 200 + (playerSize / 2)),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPlayer = player;
                                      showModal = true;
                                    });
                                  },
                                  child: PlayerWidget(
                                    player: player,
                                    playerSize: playerSize,
                                    color: fixture.away.club.color,
                                  ),
                                ),
                              );
                            }),
                            AnimatedPositioned(
                              duration: Duration(milliseconds: (_ballAnimationSpeed).round()),
                              curve: Curves.decelerate,
                              top: fixture.isHomeTeamBall
                                  ? stadiumHeight * (fixture.ballPosXY.x) / 100 - (ballSize / 2)
                                  : stadiumHeight - (stadiumHeight * (fixture.ballPosXY.x) / 100 + (ballSize / 2)),
                              left: fixture.isHomeTeamBall
                                  ? stadiumWidth * (fixture.ballPosXY.y) / 200 - (ballSize / 2) + 10
                                  : stadiumWidth - (stadiumWidth * (fixture.ballPosXY.y) / 200 + (ballSize / 2)) - 10,
                              child: Container(
                                width: ballSize,
                                height: ballSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        fixture.gameStart();
                      },
                      child: const Text('play')),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [0, 100, 200, 500, 1000, 3000]
                        .map((speed) => ElevatedButton(
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0)),
                              onPressed: () {
                                fixture.updateTimeSpeed(Duration(milliseconds: speed));

                                _fixture.allPlayers.sort((a, b) => a.playSpeed > b.playSpeed ? 1 : -1);

                                _ballAnimationSpeed = _fixture.allPlayers.first.playSpeed.inMilliseconds;
                              },
                              child: Text('${speed}'),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: fixture.records.length,
                        itemBuilder: (context, index) => Text(
                              '${fixture.records[index].time.inMinutes} -${fixture.records[index].player?.backNumber} ${fixture.records[index].player?.name} /${fixture.records[index].action}',
                              style: TextStyle(color: fixture.records[index].club?.color),
                            )),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [true, false]
                        .map((e) => ElevatedButton(
                              onPressed: () {
                                fixture.stopWhenGoal = e;
                              },
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          if (showModal)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showModal = false;
                        _selectedPlayer = null;
                      });
                    },
                    child: const Text('x')),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('키'),
                    Text('축구지능'),
                    Text('반응속도'),
                    Text('스피드'),
                    Text('유연성'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selectedPlayer?.height.round()}'),
                    Text('${_selectedPlayer?.soccerIQ}'),
                    Text('${_selectedPlayer?.reflex}'),
                    Text('${_selectedPlayer?.speed}'),
                    Text('${_selectedPlayer?.flexibility}'),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('체력'),
                    Text('근력'),
                    Text('공격스킬'),
                    Text('패스스킬'),
                    Text('수비스킬'),
                    Text('침착함'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selectedPlayer?.stat.stamina}'),
                    Text('${_selectedPlayer?.stat.strength}'),
                    Text('${_selectedPlayer?.stat.attSkill}'),
                    Text('${_selectedPlayer?.stat.passSkill}'),
                    Text('${_selectedPlayer?.stat.defSkill}'),
                    Text('${_selectedPlayer?.stat.composure}'),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('슈팅'),
                    Text('중거리'),
                    Text('탈압박'),
                    Text('압박'),
                    Text('시야'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selectedPlayer?.shootingStat}'),
                    Text('${_selectedPlayer?.midRangeShootStat}'),
                    Text('${_selectedPlayer?.evadePressStat}'),
                    Text('${_selectedPlayer?.pressureStat}'),
                    Text('${_selectedPlayer?.visionStat}'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 120, child: Text('name')),
                    Text(_selectedPlayer?.name ?? ''),
                  ],
                ),
                ...[
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('goal')),
                      Text(_selectedPlayer?.seasonGoal.toString() ?? ''),
                    ],
                  ),
                ]
              ]),
            )
        ],
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key? key, required this.player, required this.playerSize, required this.color}) : super(key: key);
  final Player player;
  final double playerSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: playerSize,
      height: playerSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(playerSize),
      ),
      child: Center(
        child: Text(
          '${player.backNumber}',
          style:
              TextStyle(color: player.hasBall ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
