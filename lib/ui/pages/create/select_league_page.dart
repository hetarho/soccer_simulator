// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';

class SelectLeaguePage extends ConsumerStatefulWidget {
  const SelectLeaguePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectLeaguePageState();
}

class _SelectLeaguePageState extends ConsumerState<SelectLeaguePage> {
  LeagueSeedData? selectedSeed;
  _onClickLeague(LeagueSeedData seed) {
    selectedSeed = seed;
    ref.read(createSaveSlotProvider.notifier).state.selectedLeagueSeed = seed;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    englandLeagueSeedData;
    spainLeagueSeedData;
    germanyLeagueSeedData;
    italyLeagueSeedData;
    franceLeagueSeedData;
    netherlandsLeagueSeedData;
    portugalLeagueSeedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select League'),
        backgroundColor: Colors.grey[200],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _LeagueCard(
                seeds: englandLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: spainLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: germanyLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: italyLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: franceLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: netherlandsLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
              const Gap(24),
              _LeagueCard(
                seeds: portugalLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: selectedSeed == null
          ? null
          : Container(
              width: double.infinity,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    offset: Offset(0, -0),
                    blurRadius: 15,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Text(
                'SELECT',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  final List<LeagueSeedData> seeds;
  final LeagueSeedData? selectedSeed;
  final void Function(LeagueSeedData seed) onClick;

  const _LeagueCard({required this.seeds, required this.selectedSeed, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          seeds.first.national.toString(),
          style: const TextStyle(fontSize: 28),
        ),
        const Gap(8),
        ...seeds.map((seed) => GestureDetector(
              onTap: () {
                onClick(seed);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.only(bottom: 12),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(156, 39, 176, seed == selectedSeed ? 1 : 0.6),
                            Color.fromRGBO(0, 243, 220, seed == selectedSeed ? 1 : 0.6),
                          ],
                          stops: [
                            0.2,
                            0.8,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: seed == selectedSeed ? 125 : 90,
                        height: seed == selectedSeed ? 125 : 90,
                        child: Image.asset(
                          'assets/images/logo/league/pl.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        seed.name,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
