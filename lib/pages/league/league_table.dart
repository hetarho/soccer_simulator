import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/providers/providers.dart';

class LeagueTableWidget extends ConsumerWidget {
  const LeagueTableWidget({super.key, required this.clubs});
  final List<Club> clubs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = 1;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.black),
          )),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20, child: Text('')),
              SizedBox(width: 120, child: Text('name')),
              SizedBox(width: 35, child: Text('pts')),
              SizedBox(width: 35, child: Text('win')),
              SizedBox(width: 35, child: Text('draw')),
              SizedBox(width: 35, child: Text('lose')),
              SizedBox(width: 35, child: Text('gf')),
              SizedBox(width: 35, child: Text('ga')),
              SizedBox(width: 35, child: Text('gd')),
              SizedBox(width: 50, child: Text('shoot')),
              SizedBox(width: 50, child: Text('tackle')),
              SizedBox(width: 50, child: Text('pass')),
            ],
          ),
        ),
        ...clubs
            .map((club) => GestureDetector(
                  onTap: () {
                    ref.read(playerListProvider.notifier).state = club.startPlayers;
                    context.push('/players');
                  },
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20, child: Text('${index++}.')),
                        SizedBox(width: 120, child: Text('${club.nickName}(${club.overall})')),
                        SizedBox(width: 35, child: Text('${club.pts}')),
                        SizedBox(width: 35, child: Text('${club.won}')),
                        SizedBox(width: 35, child: Text('${club.drawn}')),
                        SizedBox(width: 35, child: Text('${club.lost}')),
                        SizedBox(width: 35, child: Text('${club.gf}')),
                        SizedBox(width: 35, child: Text('${club.ga}')),
                        SizedBox(width: 35, child: Text('${club.gd}')),
                        SizedBox(width: 50, child: Text((club.seasonShooting / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                        SizedBox(width: 50, child: Text((club.seasonDefSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                        SizedBox(width: 50, child: Text((club.seasonPassSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
