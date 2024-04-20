import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/data/formations/formation3241.dart';
import 'package:soccer_simulator/data/formations/formation352.dart';
import 'package:soccer_simulator/data/formations/formation41212.dart';
import 'package:soccer_simulator/data/formations/formation4141.dart';
import 'package:soccer_simulator/data/formations/formation4222.dart';
import 'package:soccer_simulator/data/formations/formation433.dart';
import 'package:soccer_simulator/data/formations/formation442.dart';
import 'package:soccer_simulator/data/formations/formation532.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/league.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/stat.dart';
import 'package:soccer_simulator/entities/tactics.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/utils/random.dart';

Club arsenal = Club(
  name: 'Arsenal',
  homeColor: Colors.red,
  awayColor: Colors.yellow,
  tactics: Tactics(pressDistance: 30),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation433.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 80,
          max: 135,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation433.positions[index].position,
            min: 80,
            max: 135,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation433.positions[index].position
          ..startingPoxXY = formation433.positions[index].pos);

Club manchesterCity = Club(
  name: 'manchesterCity',
  homeColor: Colors.blue[100]!,
  awayColor: Colors.blue[800]!,
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation433.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 100,
          max: 110,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation433.positions[index].position,
            passSkill: 110 + R().getInt(max: 10),
            min: 100,
            max: 110,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation433.positions[index].position
          ..startingPoxXY = formation433.positions[index].pos);

Club liverfpool = Club(
  name: 'liverpool',
  homeColor: Colors.red[800]!,
  awayColor: Colors.blue[900]!,
  tactics: Tactics(pressDistance: 40),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation433.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 70,
          max: 140,
          tactics: Tactics(pressDistance: 5),
          stat: Stat.random(
            position: formation433.positions[index].position,
            min: 70,
            max: 140,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation433.positions[index].position
          ..startingPoxXY = formation433.positions[index].pos);

Club astonVilla = Club(
  name: 'Aston Villa',
  homeColor: const Color.fromARGB(255, 135, 45, 88),
  awayColor: const Color.fromRGBO(140, 188, 229, 1),
  tactics: Tactics(pressDistance: 15),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation4222.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 60,
          max: 105,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation4222.positions[index].position,
            min: 60,
            max: 105,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation4222.positions[index].position
          ..startingPoxXY = formation4222.positions[index].pos);

Club tottenham = Club(
  name: 'Tottenham Hotspur',
  homeColor: Colors.white,
  awayColor: const Color.fromRGBO(19, 30, 72, 1),
  tactics: Tactics(pressDistance: 10),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation532.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 65,
          max: 95,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation532.positions[index].position,
            min: 65,
            max: 95,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation532.positions[index].position
          ..startingPoxXY = formation532.positions[index].pos);

Club newcastle = Club(
  name: 'Newcastle United',
  homeColor: Colors.black,
  awayColor: Colors.white,
  tactics: Tactics(pressDistance: 35),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation352.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 80,
          max: 120,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation352.positions[index].position,
            min: 80,
            max: 120,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation352.positions[index].position
          ..startingPoxXY = formation352.positions[index].pos);

Club manchesterUnited = Club(
  name: 'Manchester United',
  homeColor: Colors.red,
  awayColor: Colors.green[200]!,
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation4222.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 70,
          max: 80,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation4222.positions[index].position,
            min: 70,
            max: 80,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation4222.positions[index].position
          ..startingPoxXY = formation4222.positions[index].pos);

Club westHam = Club(
  name: 'West Ham United',
  homeColor: const Color.fromARGB(255, 112, 45, 52),
  awayColor: const Color.fromRGBO(179, 110, 70, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation442.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 65,
          max: 90,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation442.positions[index].position,
            min: 65,
            max: 90,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation442.positions[index].position
          ..startingPoxXY = formation442.positions[index].pos);

Club chelsea = Club(
  name: 'Chelsea',
  homeColor: const Color.fromARGB(255, 0, 27, 123),
  awayColor: const Color.fromRGBO(80, 70, 85, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation433.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 60,
          max: 90,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation433.positions[index].position,
            min: 60,
            max: 90,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation433.positions[index].position
          ..startingPoxXY = formation433.positions[index].pos);

Club brighton = Club(
  name: 'Brighton And Hov Albion',
  homeColor: const Color.fromARGB(255, 0, 77, 152),
  awayColor: const Color.fromRGBO(80, 255, 255, 255),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation3241.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 85,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation3241.positions[index].position,
            min: 55,
            max: 85,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation3241.positions[index].position
          ..startingPoxXY = formation3241.positions[index].pos);

Club wolverhampton = Club(
  name: 'Wolverhampton Wanderers',
  homeColor: const Color.fromARGB(255, 250, 174, 40),
  awayColor: const Color.fromRGBO(27, 27, 27, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation442.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 80,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation442.positions[index].position,
            min: 55,
            max: 80,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation442.positions[index].position
          ..startingPoxXY = formation442.positions[index].pos);

Club folham = Club(
  name: 'Fulham',
  homeColor: const Color.fromARGB(255, 15, 15, 15),
  awayColor: const Color.fromRGBO(150, 27, 27, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation4141.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 75,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation4141.positions[index].position,
            min: 55,
            max: 75,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation4141.positions[index].position
          ..startingPoxXY = formation4141.positions[index].pos);

Club bournemouth = Club(
  name: 'Bournemouth',
  homeColor: const Color.fromARGB(255, 200, 6, 20),
  awayColor: const Color.fromRGBO(120, 120, 120, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation4222.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 70,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation4222.positions[index].position,
            min: 55,
            max: 70,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation4222.positions[index].position
          ..startingPoxXY = formation4222.positions[index].pos);

Club crystalPalace = Club(
  name: 'Crystal Palace',
  homeColor: const Color.fromARGB(255, 15, 45, 115),
  awayColor: const Color.fromRGBO(70, 5, 30, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation352.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 70,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation352.positions[index].position,
            min: 55,
            max: 70,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation352.positions[index].position
          ..startingPoxXY = formation352.positions[index].pos);

Club brentford = Club(
  name: 'Brentford',
  homeColor: const Color.fromARGB(255, 180, 0, 15),
  awayColor: const Color.fromRGBO(70, 25, 25, 25),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation41212.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 55,
          max: 70,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation41212.positions[index].position,
            min: 55,
            max: 70,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation41212.positions[index].position
          ..startingPoxXY = formation41212.positions[index].pos);

Club everton = Club(
  name: 'Everton',
  homeColor: const Color.fromARGB(255, 0, 60, 140),
  awayColor: const Color.fromRGBO(70, 15, 15, 15),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation433.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 50,
          max: 70,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation433.positions[index].position,
            min: 50,
            max: 70,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation433.positions[index].position
          ..startingPoxXY = formation433.positions[index].pos);

Club nottingham = Club(
  name: 'Nottingham Forest',
  homeColor: const Color.fromARGB(255, 230, 35, 55),
  awayColor: const Color.fromRGBO(230, 230, 230, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation4141.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 50,
          max: 65,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation4141.positions[index].position,
            min: 50,
            max: 65,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation4141.positions[index].position
          ..startingPoxXY = formation4141.positions[index].pos);

Club lutonTown = Club(
  name: 'Luton Town',
  homeColor: const Color.fromARGB(255, 130, 130, 110),
  awayColor: const Color.fromRGBO(90, 100, 150, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation3241.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 50,
          max: 65,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation3241.positions[index].position,
            min: 50,
            max: 65,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation3241.positions[index].position
          ..startingPoxXY = formation3241.positions[index].pos);

Club burnley = Club(
  name: 'Burnley',
  homeColor: const Color.fromARGB(255, 77, 5, 50),
  awayColor: const Color.fromRGBO(90, 100, 150, 1),
  tactics: Tactics(pressDistance: 5),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation352.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 50,
          max: 65,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation352.positions[index].position,
            min: 50,
            max: 65,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation352.positions[index].position
          ..startingPoxXY = formation352.positions[index].pos);

Club sheffield = Club(
  name: 'Sheffield United',
  homeColor: const Color.fromARGB(255, 223, 22, 35),
  awayColor: const Color.fromRGBO(0, 0, 0, 1),
  tactics: Tactics(pressDistance: 25),
)..players = List.generate(
    11,
    (index) => Player.random(
          name: RandomNames(Zone.us).name(),
          backNumber: index,
          position: formation41212.positions[index].position,
          birthDay: DateTime(2002, 03, 01),
          national: National.england,
          min: 50,
          max: 65,
          tactics: Tactics.normal(),
          stat: Stat.random(
            position: formation41212.positions[index].position,
            min: 50,
            max: 65,
          ),
        )
          ..isStartingPlayer = true
          ..position = formation41212.positions[index].position
          ..startingPoxXY = formation41212.positions[index].pos);

List<Club> clubs = [
  arsenal,
  manchesterCity,
  liverfpool,
  astonVilla,
  tottenham,
  newcastle,
  manchesterUnited,
  westHam,
  chelsea,
  brighton,
  wolverhampton,
  folham,
  bournemouth,
  crystalPalace,
  brentford,
  everton,
  nottingham,
  lutonTown,
  burnley,
  sheffield,
];

League epl = League(clubs: clubs);
