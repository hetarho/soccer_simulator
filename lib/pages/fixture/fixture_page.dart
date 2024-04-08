import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/providers/fixture_provider.dart';

class FixturePage extends ConsumerStatefulWidget {
  const FixturePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixturePageState();
}

class _FixturePageState extends ConsumerState<FixturePage> {
  bool isFastMode = true;

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Container()),
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
            AspectRatio(
              aspectRatio: 1.6,
              child: LayoutBuilder(builder: (context, constraints) {
                final stadiumWidth = constraints.maxWidth;
                final stadiumHeight = constraints.maxHeight;
                const double playerSize = 30;
                const double ballSize = 20;
                return Stack(
                  children: [
                    Container(
                      color: Colors.green,
                    ),
                    ...fixture.home.club.startPlayers.map((player) {
                      bool hasBall = player.id == fixture.playerWithBall?.id;
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round()),
                        curve: Curves.linear,
                        top: stadiumHeight * (player.posXY.x) / 100 - (playerSize / 2),
                        left: stadiumWidth * (player.posXY.y) / 200 - (playerSize / 2),
                        child: Container(
                          width: playerSize * (hasBall ? 1.1 : 1),
                          height: playerSize * (hasBall ? 1.1 : 1),
                          decoration: BoxDecoration(
                            color: fixture.home.club.color,
                            borderRadius: BorderRadius.circular(playerSize),
                          ),
                        ),
                      );
                    }),
                    ...fixture.away.club.startPlayers.map((player) {
                      bool hasBall = player.id == fixture.playerWithBall?.id;
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round()),
                        curve: Curves.easeIn,
                        top: stadiumHeight - (stadiumHeight * (player.posXY.x) / 100 + (playerSize / 2)),
                        left: stadiumWidth - (stadiumWidth * (player.posXY.y) / 200 + (playerSize / 2)),
                        child: Container(
                          width: playerSize * (hasBall ? 1.1 : 1),
                          height: playerSize * (hasBall ? 1.1 : 1),
                          decoration: BoxDecoration(
                            color: fixture.away.club.color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    }),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: (fixture.playSpeed.inMilliseconds / 1).round()),
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
            ElevatedButton(
                onPressed: () {
                  fixture.gameStart();
                },
                child: const Text('play')),
            ElevatedButton(
                onPressed: () {
                  fixture.pause();
                },
                child: const Text('pause')),
            Text('play time : ${fixture.playTime}'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(fixture.home.club.name),
                Text(fixture.home.goal.toString()),
                const SizedBox(width: 16),
                const Text('vs'),
                const SizedBox(width: 16),
                Text(fixture.away.goal.toString()),
                Text(fixture.away.club.name),
              ],
            ),
            ...fixture.records.map((record) => Text('${record.time.inMinutes} - ${record.scoredClub.name} /${record.scoredPlayer.name}/${record.assistPlayer.name}')),
            ElevatedButton(
                onPressed: () {
                  fixture.updateTimeSpeed(isFastMode ? const Duration(milliseconds: 100) : const Duration(milliseconds: 10));
                  isFastMode = !isFastMode;
                },
                child: const Text('스피드 빠르게 / 느리게')),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
