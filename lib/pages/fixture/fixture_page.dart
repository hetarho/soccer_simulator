import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(fixtureProvider)?.gameStream.listen((event) {
      if (mounted) setState(() {});
    });
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
            AspectRatio(
              aspectRatio: 1.6,
              child: LayoutBuilder(builder: (context, constraints) {
                final stadiumWidth = constraints.maxWidth;
                final stadiumHeight = constraints.maxHeight;

                return Stack(
                  children: [
                    Container(
                      color: Colors.green,
                    ),
                    ...fixture.home.club.startPlayers.map((player) {
                      return Positioned(
                        top: stadiumHeight * (player.posXY?.y ?? 0) / 100 - 15,
                        left: stadiumWidth * (player.posXY?.x ?? 0) / 200 - 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: fixture.home.club.color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    }),
                    ...fixture.away.club.startPlayers.map((player) {
                      return Positioned(
                        top: stadiumHeight - (stadiumHeight * (player.posXY?.y ?? 0) / 100 + 15),
                        left: stadiumWidth - (stadiumWidth * (player.posXY?.x ?? 0) / 200 + 15),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: fixture.away.club.color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    })
                  ],
                );
              }),
            ),
            ElevatedButton(
                onPressed: () {
                  fixture.gameStart();
                },
                child: const Text('play')),
            Text('play time : ${fixture.playTime}'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (fixture != null) ...[
                  Text(fixture.home.club.name),
                  Text(fixture.home.goal.toString()),
                  const SizedBox(width: 16),
                  const Text('vs'),
                  const SizedBox(width: 16),
                  Text(fixture.away.goal.toString()),
                  Text(fixture.away.club.name),
                ],
              ],
            ),
            ...fixture.recoreds.map((record) => Text(
                '${record.time.inMinutes} - ${record.scoredClub.name} /${record.scoredPlayer.name}/${record.assistPlayer.name}')),
            ElevatedButton(
                onPressed: () {
                  fixture.updateTimeSpeed(
                      isFastMode ? const Duration(milliseconds: 100) : const Duration(milliseconds: 10));
                  isFastMode = !isFastMode;
                },
                child: const Text('스피드 빠르게 / 느리게'))
          ],
        ),
      ),
    );
  }
}
