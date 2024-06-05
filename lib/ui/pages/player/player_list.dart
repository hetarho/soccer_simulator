import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/domain/entities/club/club.dart';
import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/entities/pos/pos.dart';
import 'package:soccer_simulator/domain/enum/play_level.enum.dart';
import 'package:soccer_simulator/domain/enum/position.enum.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (playerList.isNotEmpty)
              Center(
                child: SizedBox(
                  height: 50,
                  child: Text(
                    playerList[0].team?.name ?? '',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            Container(
              color: Colors.green,
              padding: const EdgeInsets.only(top: 20),
              child: AspectRatio(
                aspectRatio: 1.125,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stadiumWidth = constraints.maxWidth;
                    final stadiumHeight = constraints.maxHeight;
                    double playerSize = stadiumWidth / 10;
                    return DragTarget<Player>(
                      onMove: (details) {
                        if (details.data.position != Position.gk) {
                          details.data.startingPoxXY = PosXY(
                            (100 * (details.offset.dx) / stadiumWidth + 5).clamp(0, 100),
                            (100 - (100 * (details.offset.dy - 120) / stadiumHeight - 5)).clamp(0, 100),
                          );
                        }
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
            _TacticsWidget(
              club: playerList[0].team ?? Club.empty(),
            )
          ],
        ),
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
      feedback: Container(),
      data: player,
      child: Column(
        children: [
          Container(
            width: playerSize,
            height: playerSize,
            decoration: BoxDecoration(
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

class _TacticsWidget extends StatefulWidget {
  const _TacticsWidget({Key? key, required this.club}) : super(key: key);
  final Club club;

  @override
  State<_TacticsWidget> createState() => _TacticsWidgetState();
}

class _TacticsWidgetState extends State<_TacticsWidget> {
  String distance = '0';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.club.tactics.pressDistance.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _buttonStyle = ElevatedButton.styleFrom(padding: const EdgeInsets.all(0));
    var _buttonStyleSelected = ElevatedButton.styleFrom(padding: const EdgeInsets.all(0), backgroundColor: Colors.blue[200]);

    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            const Text('distance'),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                controller: _controller,
                onChanged: (val) => distance = val,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  widget.club.tactics.pressDistance = double.parse(distance);
                },
                child: Text('change'))
          ],
        ),
        Row(
          children: [
            const Text('shortPassLevel'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.shortPassLevel = e;
                  setState(() {});
                },
                style: widget.club.tactics.shortPassLevel == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('attackLevel'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.attackLevel = e;
                  setState(() {});
                },
                style: widget.club.tactics.attackLevel == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('dribbleLevel'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.dribbleLevel = e;
                  setState(() {});
                },
                style: widget.club.tactics.dribbleLevel == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('shootLevel'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.shootLevel = e;
                  setState(() {});
                },
                style: widget.club.tactics.shootLevel == e ? _buttonStyleSelected : _buttonStyle,
                child:
                 Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('free - front'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.freeLevel.forward = e;
                  setState(() {});
                },
                style: widget.club.tactics.freeLevel.forward == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('free - back'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.freeLevel.backward = e;
                  setState(() {});
                },
                style: widget.club.tactics.freeLevel.backward == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('free - right'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.freeLevel.right = e;
                  setState(() {});
                },
                style: widget.club.tactics.freeLevel.right == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
        Row(
          children: [
            const Text('free - left'),
            ...PlayLevel.values.map((e) => ElevatedButton(
                onPressed: () {
                  widget.club.tactics.freeLevel.left = e;
                  setState(() {});
                },
                style: widget.club.tactics.freeLevel.left == e ? _buttonStyleSelected : _buttonStyle,
                child: Text(e.text))),
          ],
        ),
      ],
    );
  }
}
