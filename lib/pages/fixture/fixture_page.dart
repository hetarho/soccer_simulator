import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/player.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(fixtureProvider)?.gameStream.listen((event) {
      if (mounted) setState(() {});
    });

    ref.read(fixtureProvider)?.isSimulation = false;
  }
  @override
  Widget build(BuildContext context) {
    if (ref.read(fixtureProvider) == null) return Container();
    Fixture fixture = ref.read(fixtureProvider)!;

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
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final stadiumWidth = constraints.maxWidth;
                      final stadiumHeight = constraints.maxHeight;
                      const double playerSize = 30;
                      const double ballSize = 20;
                      return Stack(
                        children: [
                          Container(color: Colors.green),
                          ...fixture.home.club.startPlayers.map((player) {
                            return AnimatedPositioned(
                              duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round() + 50),
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
                                  color: player.hasBall ? Colors.black : fixture.home.club.color,
                                ),
                              ),
                            );
                          }),
                          ...fixture.away.club.startPlayers.map((player) {
                            return AnimatedPositioned(
                              duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round() + 50),
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
                                  color: player.hasBall ? Colors.black : fixture.away.club.color,
                                ),
                              ),
                            );
                          }),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round() + 50),
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
                  ElevatedButton(
                      onPressed: () {
                        fixture.gameStart();
                      },
                      child: const Text('play')),
                  ...fixture.records.map((record) => Text(
                      '${record.time.inMinutes} - ${record.scoredClub.name} /${record.scoredPlayer.backNumber} ${record.scoredPlayer.name}/${record.assistPlayer.backNumber} ${record.assistPlayer.name}')),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [0, 10, 100, 200, 500, 1000]
                        .map((speed) => ElevatedButton(
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0)),
                              onPressed: () {
                                fixture.updateTimeSpeed(Duration(milliseconds: speed));
                              },
                              child: Text('${speed}'),
                            ))
                        .toList(),
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
                Row(
                  children: [
                    const SizedBox(width: 120, child: Text('name')),
                    Text(_selectedPlayer?.name ?? ''),
                  ],
                ),
                if (_selectedPlayer?.gameRecord.isNotEmpty ?? false) ...[
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('goal')),
                      Text(_selectedPlayer?.gameRecord.last['goal'].toString() ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('assist')),
                      Text(_selectedPlayer?.gameRecord.last['assist'].toString() ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('pass')),
                      Text(_selectedPlayer?.gameRecord.last['passSuccess'].toString() ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('shoot')),
                      Text(_selectedPlayer?.gameRecord.last['shooting'].toString() ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('dribbleSuccess')),
                      Text(_selectedPlayer?.gameRecord.last['dribbleSuccess'].toString() ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 120, child: Text('defSuccess')),
                      Text(_selectedPlayer?.gameRecord.last['defSuccess'].toString() ?? ''),
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
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          '${player.backNumber}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
