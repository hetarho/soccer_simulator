import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/utils/color.dart';

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
                          child: _PlayerWidget(
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

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({Key? key, required this.player, required this.playerSize, required this.color}) : super(key: key);
  final Player player;
  final double playerSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Color textColor = C().colorDifference(Colors.black, color) < C().colorDifference(Colors.white, color) ? Colors.white : Colors.black;
    return Column(
      children: [
        Transform.translate(
          offset: Offset(playerSize / 2, playerSize / 2),
          child: Transform.translate(
            offset: Offset(-playerSize / 2, -playerSize / 2),
            child: Container(
              width: playerSize,
              height: playerSize,
              decoration: BoxDecoration(
                border: player.hasBall
                    ? Border.all(
                        color: textColor,
                        width: playerSize / 10,
                      )
                    : null,
                color: color,
                borderRadius: BorderRadius.circular(playerSize),
              ),
              child: Center(
                child: Text(
                  '${player.position}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: playerSize / 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: playerSize,
          alignment: Alignment.center,
          child: Text(
            '${player.overall.round()}',
            style: TextStyle(
              color: textColor,
              fontSize: playerSize / 2,
            ),
          ),
        )
      ],
    );
  }
}
