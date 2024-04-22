import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/pages/fixture/fixture_page.dart';

class PlayerListPage extends ConsumerWidget {
  const PlayerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> playerList = ref.read(playerListProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          if (playerList.isNotEmpty) Center(child: Text(playerList[0].team?.name ?? '')),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green,
            child: AspectRatio(
              aspectRatio: 1.125,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stadiumWidth = constraints.maxWidth;
                  final stadiumHeight = constraints.maxHeight;
                  double playerSize = stadiumWidth / 10;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: playerList.map((player) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: (player.playSpeed.inMilliseconds / 1).round()),
                        curve: Curves.decelerate,
                        top: stadiumHeight * (100 - player.startingPoxXY.y) / 100 - (playerSize),
                        left: stadiumWidth * (player.startingPoxXY.x) / 100 - (playerSize / 2),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(playerProvider.notifier).state = player;
                            context.push('/players/detail');
                          },
                          child: PlayerWidget(
                            player: player,
                            playerSize: playerSize,
                            color: player.role == PlayerRole.goalKeeper
                                ? Colors.yellow
                                : player.role == PlayerRole.forward
                                    ? Colors.red
                                    : player.role == PlayerRole.midfielder
                                        ? Colors.blue
                                        : Colors.orange,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
