import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';

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

  List<Player> playerList = [];

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
      position: Position.forward,
      personalTrainingTypes: [TrainingType.pass],
      tall: 177.3,
      potential: 150,
      stat: PlayerStat.create(),
    );

    playerList = List.generate(
        20 * 20 * 20,
        (index) => Player(
              name: RandomNames(Zone.us).manFullName(),
              birthDay: DateTime(2002, 03, 01),
              national: National.england,
              position: Position.forward,
              tall: 177,
              stat: PlayerStat.create(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 64),
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
                  List.generate(38, (index) {
                    _player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]);
                    _player.playGame();
                  });
                });
              },
              child: const Text('1시즌 시뮬레이션')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  List.generate(38, (index) => _player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]));
                });
              },
              child: const Text('1시즌 훈련만')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  Stopwatch stopwatch = Stopwatch();
                  stopwatch.start();
                  for (var player in playerList) {
                    List.generate(38, (index) {
                      player.training(coachAbility: 0.3, teamTrainingTypes: [TrainingType.pass]);
                      player.playGame();
                    });
                  }
                  stopwatch.stop();

                  print('걸린 시간: ${stopwatch.elapsedMilliseconds}');
                });
              },
              child: const Text('부하테스트')),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: playerList.length,
              itemBuilder: (context, index) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(playerList[index].name),
                Text(playerList[index].stat.attOverall.toString()),
                Text(playerList[index].stat.midOverall.toString()),
                Text(playerList[index].stat.defOverall.toString()),
                Text(playerList[index].potential.toString()),
              ]),
            ),
          ),
          if (false)
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
                      Text('포텐셜'),
                      Text('방향전환'),
                      Text('롱패스'),
                      Text('숏패스'),
                      Text('축구지능'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((_player.potential).toString()),
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
                      Text('공격'),
                      Text('미드필더'),
                      Text('수비'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((_player.stat.intercept ?? '-').toString()),
                      Text((_player.stat.tackle ?? '-').toString()),
                      Text((_player.stat.save ?? '-').toString()),
                      Text((_player.stat.attOverall).toString()),
                      Text((_player.stat.midOverall).toString()),
                      Text((_player.stat.defOverall).toString()),
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
