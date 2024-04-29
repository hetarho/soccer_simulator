import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/utils/color.dart';

class PlayerListPage extends ConsumerStatefulWidget {
  const PlayerListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends ConsumerState<PlayerListPage> {
  @override
  Widget build(BuildContext context) {
    final List<Player> playerList = ref.read(playerListProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
      ),
      body: Column(
        children: [
          if (playerList.isNotEmpty)
            Center(
              child: Container(
                height: 50,
                child: Text(
                  playerList[0].team?.name ?? '',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          Container(
            color: Colors.green,
            padding: const EdgeInsets.only(top: 40),
            child: AspectRatio(
              aspectRatio: 1.125,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stadiumWidth = constraints.maxWidth;
                  final stadiumHeight = constraints.maxHeight;
                  double playerSize = stadiumWidth / 10;
                  return DragTarget<Player>(
                    onAcceptWithDetails: (details) {
                      details.data.startingPoxXY = PosXY(
                        100 * (details.offset.dx) / stadiumWidth + 5,
                        100 - (100 * (details.offset.dy - 140) / stadiumHeight + 10),
                      );
                      setState(() {});
                    },
                    builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: playerList.map((player) {
                          return AnimatedPositioned(
                            duration: Duration(milliseconds: (player.playSpeed.inMilliseconds / 1).round()),
                            curve: Curves.decelerate,
                            top: stadiumHeight * (100 - player.startingPoxXY.y) / 100 - playerSize,
                            left: stadiumWidth * (player.startingPoxXY.x) / 100 - playerSize / 2,
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
    return Draggable(
      feedback: this,
      data: player,
      child: Column(
        children: [
          Container(
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
      ),
    );
  }
}
