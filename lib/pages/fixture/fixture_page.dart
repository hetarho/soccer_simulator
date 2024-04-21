import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/providers/fixture_provider.dart';
import 'package:soccer_simulator/utils/color.dart';

class FixturePage extends ConsumerStatefulWidget {
  const FixturePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixturePageState();
}

class _FixturePageState extends ConsumerState<FixturePage> {
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
    _fixture.ready();
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
                      const SizedBox(width: 4),
                      Text(fixture.home.club.name),
                      const SizedBox(width: 4),
                      Text('${fixture.homeBallPercent}%'),
                      const SizedBox(width: 16),
                      const Text('vs'),
                      const SizedBox(width: 16),
                      Text('${fixture.awayBallPercent}%'),
                      const SizedBox(width: 4),
                      Text(fixture.away.club.name),
                      const SizedBox(width: 4),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${fixture.home.goal}'),
                      const SizedBox(width: 4),
                      Text('(${fixture.home.club.overall}/${fixture.home.club.tactics.pressDistance.toStringAsFixed(1)})'),
                      const SizedBox(width: 4),
                      Text('${fixture.homeBallPercent}%'),
                      const SizedBox(width: 16),
                      const Text('vs'),
                      const SizedBox(width: 16),
                      Text('${fixture.awayBallPercent}%'),
                      const SizedBox(width: 4),
                      Text('(${fixture.away.club.overall}/${fixture.away.club.tactics.pressDistance.toStringAsFixed(1)})'),
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
                                      ref.read(playerProvider.notifier).state = player;
                                      context.push('/players/detail');
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
                                      ref.read(playerProvider.notifier).state = player;
                                      context.push('/players/detail');
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
                              top: fixture.isHomeTeamBall ? stadiumHeight * (fixture.ballPosXY.x) / 100 - (ballSize / 2) : stadiumHeight - (stadiumHeight * (fixture.ballPosXY.x) / 100 + (ballSize / 2)),
                              left: fixture.isHomeTeamBall ? stadiumWidth * (fixture.ballPosXY.y) / 200 - (ballSize / 2) + 10 : stadiumWidth - (stadiumWidth * (fixture.ballPosXY.y) / 200 + (ballSize / 2)) - 10,
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
                    children: [1, 100, 200, 500, 1000, 3000]
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
        border: player.hasBall
            ? Border.all(
                color: C().colorDifference(Colors.black, color) < C().colorDifference(Colors.white, color) ? Colors.white : Colors.black,
                width: 4,
              )
            : null,
        color: color,
        borderRadius: BorderRadius.circular(playerSize),
      ),
      child: Center(
        child: Text(
          '${player.backNumber}',
          style: TextStyle(
            color: C().colorDifference(Colors.black, color) < C().colorDifference(Colors.white, color) ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
