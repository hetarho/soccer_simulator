import 'package:flutter/material.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/enum/national.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Player _player;

  late PlayerStat _beforeStat;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _player = Player(
      name: '부카요 사카',
      birthDay: DateTime(2002, 03, 01),
      national: National.england,
      tall: 177.3,
      teamTrainingTypePercent: 0,
      personalTrainingTypes: [TrainingType.att],
      potential: 50,
      stat: PlayerStat.create(
        shoot: 50,
        shootAccuracy: 50,
        shootPower: 50,
        dribble: 50,
      ),
    );

    _beforeStat = _player.stat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                setState(() {
                  init();
                });
              },
              child: const Text('리셋')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  while (_player.potential > 0) {
                    _player.training(coachAbility: 1);
                  }
                });
              },
              child: const Text('훈련')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _player.training(coachAbility: 1);
                });
              },
              child: const Text('게임')),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('조직력'),
                    Text('스피드'),
                    Text('점프'),
                    Text('피지컬'),
                    Text('체력'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((_player.stat.organization ?? '-').toString()),
                    Text((_player.stat.speed ?? '-').toString()),
                    Text((_player.stat.jump ?? '-').toString()),
                    Text((_player.stat.physical ?? '-').toString()),
                    Text((_player.stat.stamina ?? '-').toString()),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('드리블'),
                    Text('슈팅'),
                    Text('슈팅파워'),
                    Text('슈팅 정확도'),
                    Text('키패스'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((_player.stat.dribble ?? '-').toString()),
                    Text((_player.stat.shoot ?? '-').toString()),
                    Text((_player.stat.shootPower ?? '-').toString()),
                    Text((_player.stat.shootAccuracy ?? '-').toString()),
                    Text((_player.stat.keyPass ?? '-').toString()),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('키패스'),
                    Text('방향전환'),
                    Text('롱패스'),
                    Text('숏패스'),
                    Text('축구지능'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((_player.stat.keyPass ?? '-').toString()),
                    Text((_player.stat.reorientation ?? '-').toString()),
                    Text((_player.stat.longPass ?? '-').toString()),
                    Text((_player.stat.shortPass ?? '-').toString()),
                    Text((_player.stat.sQ ?? '-').toString()),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('가로채기'),
                    Text('태클'),
                    Text('선방'),
                    Text('포텐셜'),
                    Text(''),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((_player.stat.intercept ?? '-').toString()),
                    Text((_player.stat.tackle ?? '-').toString()),
                    Text((_player.stat.save ?? '-').toString()),
                    Text(_player.potential.toString()),
                    const Text(''),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
