import 'package:soccer_simulator/domain/enum/national.enum.dart';

class LeagueSeedData {
  final String name;
  final National national;
  final int level;
  LeagueSeedData({
    required this.name,
    required this.national,
    required this.level,
  });
}

List<LeagueSeedData> englandLeagueSeedData = [
  LeagueSeedData(name: 'Premier League', national: National.england, level: 0),
  LeagueSeedData(name: 'Championship', national: National.england, level: 1),
  LeagueSeedData(name: 'League One', national: National.england, level: 2),
  LeagueSeedData(name: 'League Two', national: National.england, level: 3),
];

List<LeagueSeedData> spainLeagueSeedData = [
  LeagueSeedData(name: 'La Liga', national: National.spain, level: 0),
  LeagueSeedData(name: 'Segunda División', national: National.spain, level: 1),
  LeagueSeedData(name: 'Primera Federación', national: National.spain, level: 2),
  LeagueSeedData(name: 'Segunda Federación', national: National.spain, level: 3),
];

List<LeagueSeedData> germanyLeagueSeedData = [
  LeagueSeedData(name: 'Bundesliga', national: National.germany, level: 0),
  LeagueSeedData(name: 'Bundesliga2', national: National.germany, level: 1),
];

List<LeagueSeedData> italyLeagueSeedData = [
  LeagueSeedData(name: 'Serie A', national: National.italy, level: 0),
  LeagueSeedData(name: 'Serie B', national: National.italy, level: 1),
  LeagueSeedData(name: 'Serie C', national: National.italy, level: 2),
  LeagueSeedData(name: 'Serie D', national: National.italy, level: 3),
];

List<LeagueSeedData> franceLeagueSeedData = [
  LeagueSeedData(name: 'Ligue 1', national: National.france, level: 0),
  LeagueSeedData(name: 'Ligue 2', national: National.france, level: 1),
];

List<LeagueSeedData> netherlandsLeagueSeedData = [
  LeagueSeedData(name: 'Eredivisie', national: National.netherlands, level: 0),
];

List<LeagueSeedData> portugalLeagueSeedData = [
  LeagueSeedData(name: 'Primeira Liga', national: National.portugal, level: 0),
];
