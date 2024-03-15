import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/main.dart';

class PlayerDetail extends ConsumerWidget {
  const PlayerDetail({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Player _player = ref.read(playerProvider) ?? Player(name: '', birthDay: DateTime.now(), national: National.algeria, tall: 123, stat: PlayerStat());
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
                Text((_player.stat.organization ?? '-').toString()),
                Text((_player.stat.speed ?? '-').toString()),
                Text((_player.stat.jump ?? '-').toString()),
                Text((_player.stat.physical ?? '-').toString()),
                Text((_player.stat.stamina ?? '-').toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text('드리블'),
                ),
                const Text('슈팅'),
                const Text('슈팅파워'),
                const Text('슈팅 정확도'),
                const Text('키패스'),
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
