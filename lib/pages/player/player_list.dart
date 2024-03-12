import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/main.dart';

class PlayerListPage extends ConsumerWidget {
  const PlayerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> playerList = ref.read(playerListProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemCount: playerList.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              ref.read(playerProvider.notifier).state = playerList[index];
              context.push('/players/detail');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(playerList[index].name),
                Text(playerList[index].stat.attOverall.toString()),
                Text(playerList[index].stat.midOverall.toString()),
                Text(playerList[index].stat.defOverall.toString()),
                Text(playerList[index].potential.toString()),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
