import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/league/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/providers/providers.dart';

class PlayerTableWidget extends ConsumerStatefulWidget {
  const PlayerTableWidget({super.key, required this.league});
  final League league;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends ConsumerState<PlayerTableWidget> {
  List<Player> _allPlayer = [];

  @override
  void initState() {
    super.initState();
    _allPlayer = widget.league.allPlayer;
  }

  _changeSort(String sortBy) {
    _allPlayer.sort((a, b) => switch (sortBy) {
                  'ov' => b.overall,
                  'assist' => b.seasonAssist,
                  'pass' => b.seasonPassSuccess,
                  'def' => b.seasonDefSuccess,
                  'shoot' => b.seasonShooting,
                  'onTarget' => b.seasonShootOnTarget,
                  'seasonShootAccuracy' => b.seasonShootAccuracy,
                  'passT' => b.seasonPassTry,
                  'passS' => b.seasonPassSuccessPercent,
                  'drib' => b.seasonDribbleSuccess,
                  'inter' => b.seasonIntercept,
                  _ => b.seasonGoal,
                } -
                switch (sortBy) {
                  'ov' => a.overall,
                  'assist' => a.seasonAssist,
                  'pass' => a.seasonPassSuccess,
                  'def' => a.seasonDefSuccess,
                  'shoot' => a.seasonShooting,
                  'onTarget' => a.seasonShootOnTarget,
                  'seasonShootAccuracy' => a.seasonShootAccuracy,
                  'passT' => a.seasonPassTry,
                  'passS' => a.seasonPassSuccessPercent,
                  'drib' => a.seasonDribbleSuccess,
                  'inter' => a.seasonIntercept,
                  _ => a.seasonGoal,
                } >
            0
        ? 1
        : -1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
            child: Container(
              color: const Color.fromARGB(255, 229, 229, 229),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.black),
                    )),
                    // ignore: prefer_const_constructors
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(width: 50, child: Text('club')),
                        SizedBox(width: 65, child: Text('name')),
                        SizedBox(width: 40, child: Text('pos')),
                      ],
                    ),
                  ),
                  ..._allPlayer
                      .map((player) => GestureDetector(
                            onTap: () {
                              ref.read(playerProvider.notifier).state = player;
                              context.push('/players/detail');
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                              )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 50, child: Text(player.team?.nickName ?? 'none')),
                                  SizedBox(width: 65, child: Text(player.name, overflow: TextOverflow.ellipsis)),
                                  SizedBox(width: 40, child: Text('${player.position}')),
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('ov');
                                });
                              },
                              child: const SizedBox(width: 50, child: Text('ov'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('goal');
                                });
                              },
                              child: const SizedBox(width: 50, child: Text('goal'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('shoot');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('shoot'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('onTarget');
                                });
                              },
                              child: const SizedBox(width: 80, child: Text('onTarget'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('seasonShootAccuracy');
                                });
                              },
                              child: const SizedBox(width: 60, child: Text('shootA'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('assist');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('assist'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('pass');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('pass'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('passT');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('passT'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('passS');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('passS'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('def');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('def'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('drib');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('drib'))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _changeSort('inter');
                                });
                              },
                              child: const SizedBox(width: 55, child: Text('inter'))),
                        ],
                      ),
                    ),
                    ..._allPlayer
                        .map((player) => GestureDetector(
                              onTap: () {
                                ref.read(playerProvider.notifier).state = player;
                                context.push('/players/detail');
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 35, child: Text('${player.overall}')),
                                    SizedBox(width: 50, child: Text('${player.seasonGoal}')),
                                    SizedBox(width: 55, child: Text('${player.seasonShooting}')),
                                    SizedBox(width: 80, child: Text('${player.seasonShootOnTarget}')),
                                    SizedBox(width: 60, child: Text('${player.seasonShootAccuracy}')),
                                    SizedBox(width: 55, child: Text('${player.seasonAssist}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassTry}')),
                                    SizedBox(width: 55, child: Text('${player.seasonPassSuccessPercent}')),
                                    SizedBox(width: 55, child: Text('${player.seasonDefSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonDribbleSuccess}')),
                                    SizedBox(width: 55, child: Text('${player.seasonIntercept}')),
                                  ],
                                ),
                              ),
                            ))
                        .toList()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
