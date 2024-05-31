import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/const/club_seed_data.dart';
import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
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

      List<ClubSeedData> _epl = [
        ClubSeedData(
          name: 'arsenal',
          nickName: 'ARS',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(239, 1, 7, 1),
          awayColor: const Color.fromRGBO(212, 233, 79, 1),
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'astonVilla',
          nickName: 'AV',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(149, 191, 229, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'bournemouth',
          nickName: 'BOU',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(239, 1, 7, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'brentford',
          nickName: 'BFD',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(227, 6, 19, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'brighton',
          nickName: 'BHA',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(0, 87, 184, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'chelsea',
          nickName: 'CHE',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(3, 70, 148, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'crystalPalace',
          nickName: 'CP',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(27, 69, 143, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'everton',
          nickName: 'EVE',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(0, 51, 153, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'folham',
          nickName: 'FUL',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(0, 0, 0, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'Ipswich Town',
          nickName: 'IPS',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(0, 51, 160, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'leister city',
          nickName: 'LEI',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(0, 48, 144, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'liverfpool',
          nickName: 'LIV',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(200, 16, 46, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'manchesterCity',
          nickName: 'MCI',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(108, 171, 221, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'manchesterUnited',
          nickName: 'MUN',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(218, 41, 28, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'newcastle',
          nickName: 'NEW',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(36, 31, 32, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'nottingham',
          nickName: 'NOF',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(229, 50, 51, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'south hampton',
          nickName: 'SOU',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(215, 25, 32, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'tottenham',
          nickName: 'TOT',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(19, 34, 87, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'westHam',
          nickName: 'WHU',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(122, 38, 58, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
        ClubSeedData(
          name: 'wolverhampton',
          nickName: 'WOV',
          national: National.england,
          level: 0,
          homeColor: const Color.fromRGBO(253, 185, 19, 1),
          awayColor: Colors.cyan,
          tactics: Tactics.normal(),
        ),
      ];
      _seedClubs = _epl;
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
          padding: const EdgeInsets.all(16).add(const EdgeInsets.only(bottom: 60)),
          child: Column(
            children: _seedClubs
                .map(
                  (seed) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSeed = seed;
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
                context.push(SelectClubPage.routes);
              },
              child: Container(
                width: double.infinity,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
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
                    fontSize: 36,
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
      height: 60,
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
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
