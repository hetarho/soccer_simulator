import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/providers/providers.dart';
import 'package:soccer_simulator/utils/color.dart';

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
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 25, child: Text('')),
                SizedBox(width: 70, child: Text('name')),
                SizedBox(width: 35, child: Text('pts')),
                SizedBox(width: 4),
                SizedBox(width: 18, child: Text('w')),
                SizedBox(width: 18, child: Text('d')),
                SizedBox(width: 18, child: Text('l')),
                SizedBox(width: 8),
                SizedBox(width: 20, child: Text('gf')),
                SizedBox(width: 20, child: Text('ga')),
                SizedBox(width: 25, child: Text('gd')),
                SizedBox(width: 4),
                SizedBox(width: 50, child: Text('shoot')),
                SizedBox(width: 50, child: Text('tackle')),
                SizedBox(width: 50, child: Text('pass')),
              ],
            ),
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
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DefaultTextStyle(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black.withOpacity(0.1),
                                fontSize: 15,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 25, child: Text('$index')),
                              SizedBox(width: 70, child: Text('${club.nickName}(${club.overall})')),
                              SizedBox(width: 35, child: Text('${club.pts}')),
                              const SizedBox(width: 4),
                              SizedBox(width: 18, child: Text('${club.won}')),
                              SizedBox(width: 18, child: Text('${club.drawn}')),
                              SizedBox(width: 18, child: Text('${club.lost}')),
                              SizedBox(width: 8),
                              SizedBox(width: 20, child: Text('${club.gf}')),
                              SizedBox(width: 20, child: Text('${club.ga}')),
                              SizedBox(width: 25, child: Text('${club.gd}')),
                              SizedBox(width: 4),
                              SizedBox(width: 50, child: Text((club.seasonShooting / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                              SizedBox(width: 50, child: Text((club.seasonDefSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                              SizedBox(width: 50, child: Text((club.seasonPassSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                            ],
                          ),
                        ),
                        DefaultTextStyle(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 25, child: Text('${index++}')),
                              SizedBox(
                                  width: 70,
                                  child: Text('${club.nickName}(${club.overall})',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: C().colorDifference(club.homeColor, Colors.white) > 100 ? club.homeColor.withOpacity(0.7) : club.awayColor,
                                          ))),
                              SizedBox(width: 35, child: Text('${club.pts}')),
                              SizedBox(width: 4),
                              SizedBox(width: 18, child: Text('${club.won}')),
                              SizedBox(width: 18, child: Text('${club.drawn}')),
                              SizedBox(width: 18, child: Text('${club.lost}')),
                              SizedBox(width: 8),
                              SizedBox(
                                  width: 20,
                                  child: Text(
                                    '${club.gf}',
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              SizedBox(
                                  width: 20,
                                  child: Text(
                                    '${club.ga}',
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              SizedBox(
                                  width: 25,
                                  child: Text(
                                    '${club.gd}',
                                    style: TextStyle(color: club.gd > 0 ? Colors.blue[700] : Colors.red[700]),
                                  )),
                              SizedBox(width: 4),
                              SizedBox(width: 50, child: Text((club.seasonShooting / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                              SizedBox(width: 50, child: Text((club.seasonDefSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                              SizedBox(width: 50, child: Text((club.seasonPassSuccess / (club.won + club.drawn + club.lost)).toStringAsFixed(2))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
