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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Fixture? fixture = ref.read(fixtureProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  fixture?.gameStart();
                },
                child: Text('play')),
            Text('play time : ${fixture?.playTime}'),
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
            ElevatedButton(
                onPressed: () {
                  fixture?.updateTimeSpeed(isFastMode
                      ? Duration(milliseconds: 100)
                      : Duration(milliseconds: 10));
                  isFastMode = !isFastMode;
                },
                child: Text('스피드 빠르게 / 느리게'))
          ],
        ),
      ),
    );
  }
}
