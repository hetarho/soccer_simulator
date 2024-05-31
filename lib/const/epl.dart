// import 'package:flutter/material.dart';
// import 'package:soccer_simulator/domain/entities/club.dart';
// import 'package:soccer_simulator/domain/entities/formation/formation.dart';
// import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
// import 'package:soccer_simulator/domain/enum/play_level.enum.dart';

// Club arsenal = Club(
//   name: 'Arsenal',
//   nickName: 'ARS',
//   homeColor: Colors.red,
//   awayColor: Colors.yellow,
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 85,
//     formation: Formation.create4231(),
//   );

// Club manchesterCity = Club(
//   name: 'manchesterCity',
//   nickName: 'MAC',
//   homeColor: Colors.blue[100]!,
//   awayColor: Colors.blue[800]!,
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 85,
//     formation: Formation.create433(),
//   );

// Club liverfpool = Club(
//   name: 'liverpool',
//   nickName: 'LIV',
//   homeColor: Colors.red[800]!,
//   awayColor: Colors.blue[900]!,
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 85,
//     formation: Formation.create442(),
//   );

// Club astonVilla = Club(
//   name: 'Aston Villa',
//   nickName: 'AV',
//   homeColor: const Color.fromARGB(255, 135, 45, 88),
//   awayColor: const Color.fromRGBO(140, 188, 229, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 85,
//     formation: Formation.create41212(),
//   );
// Club tottenham = Club(
//   name: 'Tottenham Hotspur',
//   nickName: 'TOT',
//   homeColor: Colors.white,
//   awayColor: const Color.fromRGBO(19, 30, 72, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 85,
//     formation: Formation.create433(),
//   );
// Club newcastle = Club(
//   name: 'Newcastle United',
//   nickName: 'NEW',
//   homeColor: Colors.black,
//   awayColor: Colors.white,
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 80,
//     formation: Formation.create532(),
//   );

// Club manchesterUnited = Club(
//   name: 'Manchester United',
//   nickName: 'MU',
//   homeColor: Colors.red,
//   awayColor: Colors.green[200]!,
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 85,
//     formation: Formation.create4222(),
//   );

// Club westHam = Club(
//   name: 'West Ham United',
//   nickName: 'WHU',
//   homeColor: const Color.fromARGB(255, 112, 45, 52),
//   awayColor: const Color.fromRGBO(179, 110, 70, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 80,
//     formation: Formation.create433(),
//   );
// Club chelsea = Club(
//   name: 'Chelsea',
//   nickName: 'CHE',
//   homeColor: const Color.fromARGB(255, 0, 27, 123),
//   awayColor: const Color.fromRGBO(80, 70, 85, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 75,
//     max: 85,
//     formation: Formation.create3241(),
//   );

// Club brighton = Club(
//   name: 'Brighton And Hov Albion',
//   nickName: 'BRH',
//   homeColor: const Color.fromARGB(255, 0, 77, 152),
//   awayColor: const Color.fromRGBO(80, 255, 255, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 75,
//     formation: Formation.create352(),
//   );
// Club wolverhampton = Club(
//   name: 'Wolverhampton Wanderers',
//   nickName: 'WOV',
//   homeColor: const Color.fromARGB(255, 250, 174, 40),
//   awayColor: const Color.fromRGBO(27, 27, 27, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 75,
//     formation: Formation.create352(),
//   );

// Club folham = Club(
//   name: 'Fulham',
//   nickName: 'FUL',
//   homeColor: const Color.fromARGB(255, 15, 15, 15),
//   awayColor: const Color.fromRGBO(150, 27, 27, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 75,
//     formation: Formation.create532(),
//   );
// Club bournemouth = Club(
//   name: 'Bournemouth',
//   nickName: 'BOU',
//   homeColor: const Color.fromARGB(255, 200, 6, 20),
//   awayColor: const Color.fromRGBO(120, 120, 120, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create4141(),
//   );

// Club crystalPalace = Club(
//   name: 'Crystal Palace',
//   nickName: 'CP',
//   homeColor: const Color.fromARGB(255, 15, 45, 115),
//   awayColor: const Color.fromRGBO(70, 5, 30, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create41212(),
//   );

// Club brentford = Club(
//   name: 'Brentford',
//   nickName: 'BFD',
//   homeColor: const Color.fromARGB(255, 180, 0, 15),
//   awayColor: const Color.fromRGBO(70, 25, 25, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create433(),
//   );

// Club everton = Club(
//   name: 'Everton',
//   nickName: 'EVT',
//   homeColor: const Color.fromARGB(255, 0, 60, 140),
//   awayColor: const Color.fromRGBO(70, 15, 15, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create442(),
//   );

// Club nottingham = Club(
//   name: 'Nottingham Forest',
//   nickName: 'NOF',
//   homeColor: const Color.fromARGB(255, 230, 35, 55),
//   awayColor: const Color.fromRGBO(230, 230, 230, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create442(),
//   );

// Club lutonTown = Club(
//   name: 'Luton Town',
//   nickName: 'LT',
//   homeColor: const Color.fromARGB(255, 130, 130, 110),
//   awayColor: const Color.fromRGBO(90, 100, 150, 1),
//   tactics: Tactics(
//     pressDistance: 50,
//     freeLevel: FreeLevel(PlayLevel.max, PlayLevel.max, PlayLevel.max, PlayLevel.max),
//     attackLevel: PlayLevel.max,
//     shortPassLevel: PlayLevel.max,
//     dribbleLevel: PlayLevel.max,
//     shootLevel: PlayLevel.max,
//   ),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create3241(),
//   );

// Club burnley = Club(
//   name: 'Burnley',
//   nickName: 'BUN',
//   homeColor: const Color.fromARGB(255, 77, 5, 50),
//   awayColor: const Color.fromRGBO(90, 100, 150, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create433(),
//   );

// Club sheffield = Club(
//   name: 'Sheffield United',
//   nickName: 'SHU',
//   homeColor: const Color.fromARGB(255, 223, 22, 35),
//   awayColor: const Color.fromRGBO(0, 0, 0, 1),
//   tactics: Tactics.normal(),
// )..createStartingMembers(
//     min: 65,
//     max: 70,
//     formation: Formation.create532(),
//   );

// List<Club> eplClubs = [
//   arsenal,
//   manchesterCity,
//   liverfpool,
//   astonVilla,
//   tottenham,
//   newcastle,
//   manchesterUnited,
//   westHam,
//   chelsea,
//   brighton,
//   wolverhampton,
//   folham,
//   bournemouth,
//   crystalPalace,
//   brentford,
//   everton,
//   nottingham,
//   lutonTown,
//   burnley,
//   sheffield,
// ];
