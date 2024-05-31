// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:soccer_simulator/const/leagues_seed_data.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

class ClubSeedData {
  final String name;
  final String nickName;
  final National national;
  final int level;
  final Color homeColor;
  final Color awayColor;
  final Tactics tactics;
  ClubSeedData({
    required this.name,
    required this.nickName,
    required this.national,
    required this.level,
    required this.homeColor,
    required this.awayColor,
    required this.tactics,
  });
}

ClubSeedData createClubData(LeagueSeedData league, int index) {
  return ClubSeedData(
    name: '${league.national} $index',
    nickName: '${league.national} $index',
    national: league.national,
    level: league.level,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  );
}

List<ClubSeedData> _epl = [
  ClubSeedData(
    name: 'arsenal',
    nickName: 'ARS',
    national: National.england,
    level: 0,
    homeColor: Colors.red,
    awayColor: Colors.yellow,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'astonVilla',
    nickName: 'AV',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'bournemouth',
    nickName: 'BOU',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'brentford',
    nickName: 'BFD',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'brighton',
    nickName: 'BHA',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'chelsea',
    nickName: 'CHE',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'crystalPalace',
    nickName: 'CP',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'everton',
    nickName: 'EVE',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'folham',
    nickName: 'FUL',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'Ipswich Town',
    nickName: 'IPS',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'leister city',
    nickName: 'LEI',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'liverfpool',
    nickName: 'LIV',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'manchesterCity',
    nickName: 'MCI',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'manchesterUnited',
    nickName: 'MUN',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'newcastle',
    nickName: 'NEW',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'nottingham',
    nickName: 'NOF',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'south hampton',
    nickName: 'SOU',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'tottenham',
    nickName: 'TOT',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'westHam',
    nickName: 'WHU',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
  ClubSeedData(
    name: 'wolverhampton',
    nickName: 'WOV',
    national: National.england,
    level: 0,
    homeColor: Colors.purple,
    awayColor: Colors.cyan,
    tactics: Tactics.normal(),
  ),
];

List<ClubSeedData> clubSeedData = [
  ///잉글랜드 클럽
  ..._epl,
  ...List.generate(24, (index) => createClubData(englandLeagueSeedData[1], index)),
  ...List.generate(24, (index) => createClubData(englandLeagueSeedData[2], index)),
  ...List.generate(24, (index) => createClubData(englandLeagueSeedData[3], index)),

  ///스페인 클럽
  ...List.generate(20, (index) => createClubData(spainLeagueSeedData[0], index)),
  ...List.generate(22, (index) => createClubData(spainLeagueSeedData[1], index)),
  ...List.generate(22, (index) => createClubData(spainLeagueSeedData[2], index)),
  ...List.generate(22, (index) => createClubData(spainLeagueSeedData[3], index)),

  ///이탈리아 클럽
  ...List.generate(20, (index) => createClubData(italyLeagueSeedData[0], index)),
  ...List.generate(20, (index) => createClubData(italyLeagueSeedData[1], index)),
  ...List.generate(20, (index) => createClubData(italyLeagueSeedData[2], index)),
  ...List.generate(20, (index) => createClubData(italyLeagueSeedData[3], index)),

  ///독일 클럽
  ...List.generate(18, (index) => createClubData(germanyLeagueSeedData[0], index)),
  ...List.generate(18, (index) => createClubData(germanyLeagueSeedData[1], index)),

  ///네덜란드 클럽
  ...List.generate(18, (index) => createClubData(netherlandsLeagueSeedData[0], index)),

  ///포루투칼 클럽
  ...List.generate(18, (index) => createClubData(portugalLeagueSeedData[0], index)),
];
