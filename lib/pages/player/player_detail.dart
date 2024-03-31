import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/main.dart';

class PlayerDetail extends ConsumerWidget {
  const PlayerDetail({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Player _player = ref.read(playerProvider) ??
        Player(
          name: '',
          bodyType: BodyType.normal,
          flexibility: 0,
          reflex: 0,
          soccerIQ: 0,
          birthDay: DateTime.now(),
          national: National.algeria,
          height: 123,
          stat: PlayerStat(),
        );
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('추가스텟'),
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
                Text((_player.extraStat).toString()),
                Text((_player.stat.attSkill).toString()),
                Text((_player.stat.composure).toString()),
                Text((_player.stat.defSkill).toString()),
                Text((_player.stat.passSkill).toString()),
                Text((_player.stat.stamina).toString()),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('선호포지션'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((_player.wantPosition).toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
