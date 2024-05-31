import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/const/club_seed_data.dart';
import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/ui/pages/create/create_save_slot_page.dart';
import 'package:soccer_simulator/ui/providers/providers.dart';

class SelectClubPage extends ConsumerStatefulWidget {
  const SelectClubPage({super.key});
  static String routes = '/selectClub';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectClubPageState();
}

class _SelectClubPageState extends ConsumerState<SelectClubPage> {
  List<ClubSeedData> _seedClubs = [];
  ClubSeedData? selectedSeed;

  @override
  void initState() {
    super.initState();

    LeagueSeedData? selectedLeague = ref.read(createSaveSlotProvider).selectedLeagueSeed;

    if (selectedLeague != null) {
      List<ClubSeedData> seeds = clubSeedData
          .where(
            (seed) => seed.national == selectedLeague.national && seed.level == selectedLeague.level,
          )
          .toList();
      _seedClubs = seeds;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select club'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16).add(const EdgeInsets.only(bottom: 80, top: 16)),
          child: Column(
            children: _seedClubs
                .map(
                  (seed) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSeed = seed;
                        ref.read(createSaveSlotProvider.notifier).state.selectedClubSeed = seed;
                      });
                    },
                    child: _ClubCard(seed: seed, isSelected: selectedSeed == seed),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      bottomSheet: selectedSeed == null
          ? null
          : GestureDetector(
              onTap: () {
                context.push(CreateSaveSlotPage.routes);
              },
              child: Container(
                width: double.infinity,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedSeed?.homeColor,
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

class _ClubCard extends StatelessWidget {
  final ClubSeedData seed;
  final bool isSelected;

  const _ClubCard({required this.seed, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 68,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: seed.homeColor.withOpacity(isSelected ? 1 : 0.4),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                stops: [
                  isSelected ? 0.1 : 0.5,
                  isSelected ? 0.7 : 1,
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
              width: isSelected ? 90 : 70,
              height: isSelected ? 90 : 70,
              child: Opacity(
                opacity: isSelected ? 1 : 0.3,
                child: Image.asset(
                  'assets/images/logo/clubs/${seed.nickName}.png',
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset('assets/images/logo/league/pl.png');
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              seed.nickName,
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
