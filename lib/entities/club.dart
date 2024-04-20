// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:soccer_simulator/entities/tactics/tactics.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:uuid/uuid.dart';

import 'package:soccer_simulator/entities/player/player.dart';

class Club {
  Club({
    required this.name,
    required this.homeColor,
    required this.awayColor,
    Tactics? tactics,
  }) {
    this.tactics = tactics ?? Tactics.normal();
    color = homeColor;
  }

  Club.empty({
    this.name = '',
    this.homeColor = Colors.black,
    this.awayColor = Colors.black,
  });

  final String id = const Uuid().v4();
  final String name;
  late Color color;
  final Color homeColor;
  final Color awayColor;
  late Tactics tactics;

  bool hasBall = false;

  int won = 0;
  int drawn = 0;
  int lost = 0;

  int winStack = 0;
  int noLoseStack = 0;
  int loseStack = 0;
  int noWinStack = 0;

  ///득점수
  int gf = 0;

  ///실점 수
  int ga = 0;

  ///골득실
  get gd {
    return gf - ga;
  }

  int get pts {
    return won * 3 + drawn;
  }

  startNewSeason() {
    won = 0;
    drawn = 0;
    lost = 0;
    gf = 0;
    ga = 0;
  }

  win() {
    won++;
    winStack++;
    noLoseStack++;
    loseStack = 0;
    noWinStack = 0;
  }

  lose() {
    lost++;
    noWinStack++;
    loseStack++;
    winStack = 0;
    noLoseStack = 0;
  }

  draw() {
    drawn++;
    noWinStack++;
    noLoseStack++;
    winStack = 0;
    loseStack = 0;
  }

  newSeason() {
    won = 0;
    drawn = 0;
    lost = 0;
  }

  List<Player> get forwards => startPlayers.where((player) => player.position == Position.forward).toList();
  List<Player> get midfielders => startPlayers.where((player) => player.position == Position.midfielder).toList();
  List<Player> get defenders => startPlayers.where((player) => player.position == Position.defender || player.position == Position.goalKeeper).toList();

  int get attOverall {
    return (forwards.fold(0, (pre, curr) => pre + curr.overall) / forwards.length).round();
  }

  int get midOverall {
    return (midfielders.fold(0, (pre, curr) => pre + curr.overall) / midfielders.length).round();
  }

  int get defOverall {
    return (defenders.fold(0, (pre, curr) => pre + curr.overall) / defenders.length).round();
  }

  int get overall {
    return ((attOverall + midOverall + defOverall) / 3).round();
  }

  List<Player> players = [];
  List<Player> get startPlayers {
    return players.where((player) => player.isStartingPlayer).toList();
  }
}

class StartingPlayer {
  final Player player;
  final double startingPosX;
  final double startingPosY;

  StartingPlayer({required this.player, required this.startingPosX, required this.startingPosY});
}
