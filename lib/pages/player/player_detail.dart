import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/main.dart';

class PlayerDetail extends ConsumerWidget {
  const PlayerDetail({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Player player = ref.read(playerProvider) ??
        Player(
          name: '',
          bodyType: BodyType.normal,
          flexibility: 0,
          backNumber: 0,
          reflex: 0,
          soccerIQ: 0,
          speed: 0,
          birthDay: DateTime.now(),
          national: National.algeria,
          height: 123,
          stat: Stat(),
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
                Text('축구지능'),
                Text('반응속도'),
                Text('스피드'),
                Text('유연성'),
                Text('체력'),
                Text('잠재력'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.soccerIQ}'),
                Text('${player.reflex}'),
                Text('${player.speed}'),
                Text('${player.flexibility}'),
                Text('${player.stat.stamina}'),
                Text('${player.potential}'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('근력'),
                Text('공격스킬'),
                Text('패스스킬'),
                Text('수비스킬'),
                Text('키핑스킬'),
                Text('침착함'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.stat.strength}'),
                Text('${player.stat.attSkill}'),
                Text('${player.stat.passSkill}'),
                Text('${player.stat.defSkill}'),
                Text('${player.stat.gkSkill}'),
                Text('${player.stat.composure}'),
              ],
            ),
            const SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('슈팅'),
                Text('중거리'),
                Text('키패스'),
                Text('짧은패스'),
                Text('롱패스'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.shootingStat}'),
                Text('${player.midRangeShootStat}'),
                Text('${player.keyPassStat}'),
                Text('${player.shortPassStat}'),
                Text('${player.longPassStat}'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('헤딩'),
                Text('드리블'),
                Text('탈압박'),
                Text('태클'),
                Text('인터셉트'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.headerStat}'),
                Text('${player.dribbleStat}'),
                Text('${player.evadePressStat}'),
                Text('${player.tackleStat}'),
                Text('${player.interceptStat}'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('압박'),
                Text('침투'),
                Text('판단력'),
                Text('시야'),
                Text('선방'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.pressureStat}'),
                Text('${player.penetrationStat}'),
                Text('${player.judgementStat}'),
                Text('${player.visionStat}'),
                Text('${player.keepingStat}'),
              ],
            ),
            const SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('골'),
                Text('어시스트'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.seasonGoal}'),
                Text('${player.seasonAssist}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
