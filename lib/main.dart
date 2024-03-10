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
  final Player _player = Player(
    name: '부카요 사카',
    birthDay: DateTime(2002, 03, 01),
    national: National.england,
    tall: 177.3,
    stat: PlayerStat(),
  );

  @override
  void initState() {
    super.initState();
  }

  bool _showStat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _showStat = !_showStat;
                  setState(() {});
                },
                child: Text(
                  'show ${_player.name}`s stat',
                )),
          ),
          if (_showStat)
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('조직력'),
                      Text('조직력'),
                      Text('조직력'),
                      Text('조직력'),
                      Text('조직력'),
                    ],
                  ),
                  Row(
                    children: [
                      Text((_player.stat.organization ?? '-').toString()),
                      Text('조직력'),
                      Text('조직력'),
                      Text('조직력'),
                      Text('조직력'),
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
