// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
import 'package:soccer_simulator/ui/pages/create/select_club_page.dart';
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

  List<List<Color>> bgColors = const [
    [Color.fromRGBO(156, 39, 176, 1), Color.fromRGBO(0, 243, 220, 1)],
    [Color.fromRGBO(239, 108, 32, 1), Color.fromRGBO(255, 255, 31, 1)],
    [Color.fromRGBO(39, 86, 217, 1), Color.fromRGBO(60, 214, 235, 1)],
    [Color.fromRGBO(107, 21, 21, 1), Color.fromRGBO(255, 0, 0, 1)],
    [Color.fromRGBO(17, 33, 58, 1), Color.fromRGBO(197, 250, 60, 1)],
    [Color.fromRGBO(168, 33, 146, 1), Color.fromRGBO(45, 199, 120, 1)],
    [Color.fromRGBO(0, 123, 255, 1), Color.fromRGBO(255, 204, 153, 1)],
  ];

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
          padding: const EdgeInsets.all(16).add(const EdgeInsets.only(bottom: 120, top: 16)),
          child: Column(
            children: [
              _LeagueInNational(
                seeds: englandLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[0],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: spainLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[1],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: italyLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[2],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: germanyLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[3],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: franceLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[4],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: netherlandsLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[5],
              ),
              const Gap(24),
              _LeagueInNational(
                seeds: portugalLeagueSeedData,
                selectedSeed: selectedSeed,
                onClick: _onClickLeague,
                colors: bgColors[6],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: selectedSeed == null
          ? null
          : GestureDetector(
              onTap: () {
                context.push(SelectClubPage.routes);
              },
              child: Container(
                width: double.infinity,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: switch (selectedSeed) {
                    _ when selectedSeed?.national == National.england => bgColors[0][0],
                    _ when selectedSeed?.national == National.spain => bgColors[1][0],
                    _ when selectedSeed?.national == National.italy => bgColors[2][0],
                    _ when selectedSeed?.national == National.germany => bgColors[3][0],
                    _ when selectedSeed?.national == National.france => bgColors[4][0],
                    _ when selectedSeed?.national == National.netherlands => bgColors[5][0],
                    _ when selectedSeed?.national == National.portugal => bgColors[6][0],
                    _ => Colors.black,
                  },
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      offset: const Offset(0, -0),
                      blurRadius: 15,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Text(
                  'SELECT',
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}

class _LeagueInNational extends StatelessWidget {
  final List<LeagueSeedData> seeds;
  final LeagueSeedData? selectedSeed;
  final void Function(LeagueSeedData seed) onClick;
  final List<Color> colors;

  const _LeagueInNational({required this.seeds, required this.selectedSeed, required this.onClick, required this.colors});

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
              child: _LeagueCard(seed: seed, isSelected: seed == selectedSeed, colors: colors),
            )),
      ],
    );
  }
}

class _LeagueCard extends StatelessWidget {
  final LeagueSeedData seed;
  final bool isSelected;
  final List<Color> colors;

  const _LeagueCard({required this.seed, required this.isSelected, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isSelected ? 1 : 0.5,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: colors,
                  stops: [
                    isSelected ? 0.3 : 0.1,
                    isSelected ? 0.8 : 0.5,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 125 : 90,
              height: isSelected ? 125 : 90,
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
    );
  }
}
