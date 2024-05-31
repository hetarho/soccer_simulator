import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:soccer_simulator/domain/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/domain/entities/formation/formation.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
import 'package:soccer_simulator/domain/enum/position.enum.dart';
import 'package:soccer_simulator/ui/extension/color.extension.dart';
import 'package:soccer_simulator/utils/function.dart';
import 'package:soccer_simulator/utils/random.dart';

import 'package:soccer_simulator/domain/entities/player/player.dart';

class Club implements Jsonable {
  Club({
    required this.name,
    required this.nickName,
    required this.homeColor,
    required this.awayColor,
    required this.national,
    required this.level,
    Tactics? tactics,
  }) {
    this.tactics = tactics ?? Tactics.normal();
    color = homeColor;
  }

  Club.empty({
    this.id = '',
    this.name = '',
    this.nickName = '',
    this.national = National.algeria,
    this.level = 0,
    this.color = Colors.black,
    this.homeColor = Colors.black,
    this.awayColor = Colors.black,
  }) {
    tactics = Tactics.normal();
  }

  Club.save(Club club) {
    id = club.id;
    players = club.players;
    level = club.level;
    national = club.national;
    nickName = club.nickName;
    color = club.color;
    tactics = club.tactics;
    homeColor = club.homeColor;
    awayColor = club.awayColor;
    name = club.name;
    won = club.won;
    drawn = club.drawn;
    lost = club.lost;
    gf = club.gf;
    ga = club.ga;
    _seasonShooting = currentSeasonShooting;
    _seasonDefSuccess = currentSeasonDefSuccess;
    _seasonPassSuccess = currentSeasonPassSuccess;
  }

  void createStartingMembers({
    required int min,
    required int max,
    required Formation formation,
  }) {
    int backNumber = 1;
    players = formation.posXYList
        .map((posXY) => Player.create(
              name: RandomNames(Zone.us).name(),
              backNumber: backNumber++,
              role: getPlayerRoleFromPos(posXY),
              min: min,
              max: max,
            )
              ..isStartingPlayer = true
              ..team = this
              ..startingPoxXY = posXY)
        .toList();
  }

  late final String id;

  ///소속 국가
  late final National national;

  ///몇부 리그인지 0 => 1부리그
  late int level;

  late String name;
  late String nickName;
  late Color color;
  late Color homeColor;
  late Color awayColor;
  late Tactics tactics;
  List<ClubRecord> clubRecord = [];

  bool hasBall = false;

  int won = 0;
  int drawn = 0;
  int lost = 0;

  int winStack = 0;
  int noLoseStack = 0;
  int loseStack = 0;
  int noWinStack = 0;

  int? _seasonShooting;
  int? _seasonDefSuccess;
  int? _seasonPassSuccess;

  int get seasonShooting => _seasonShooting == null ? currentSeasonShooting : _seasonShooting!;
  int get seasonDefSuccess => _seasonDefSuccess == null ? currentSeasonDefSuccess : _seasonDefSuccess!;
  int get seasonPassSuccess => _seasonPassSuccess == null ? currentSeasonPassSuccess : _seasonPassSuccess!;

  int get currentSeasonShooting => players.fold(0, (previousValue, element) => previousValue + element.seasonShooting);
  int get currentSeasonDefSuccess => players.fold(0, (previousValue, element) => previousValue + element.seasonDefSuccess);
  int get currentSeasonPassSuccess => players.fold(0, (previousValue, element) => previousValue + element.seasonPassSuccess);

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

  int get winner => clubRecord.where((record) => record.ranking == 1).length;

  int get ptsAverage => (clubRecord.fold(0, (curr, record) => curr + record.pts) / max(1, clubRecord.length)).round();

  String get lankAverage => (clubRecord.fold(0, (curr, record) => curr + record.ranking) / max(1, clubRecord.length)).toStringAsFixed(1);

  startNewSeason(int season, int ranking) {
    if (season != 0) {
      for (var player in players) {
        {
          player.growAfterSeasonBonus(R().getDouble(max: 1) > 0.75
              ? switch (ranking) {
                  <= 1 => 1,
                  <= 2 => 2,
                  <= 4 => 1,
                  <= 7 => 0,
                  <= 10 => -1,
                  _ => -2,
                }
              : 0);
        }
      }
      clubRecord.add(ClubRecord(
        season: season,
        pts: pts,
        gf: gf,
        ga: ga,
        gd: gd,
        ranking: ranking,
      ));
    }
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

  List<Player> get forwards => startPlayers.where((player) => player.role == PlayerRole.forward).toList();
  List<Player> get midfielders => startPlayers.where((player) => player.role == PlayerRole.midfielder).toList();
  List<Player> get defenders => startPlayers.where((player) => player.role == PlayerRole.defender || player.role == PlayerRole.goalKeeper).toList();

  int get attOverall {
    return forwards.isEmpty ? 0 : (forwards.fold(0, (pre, curr) => pre + curr.overall) / forwards.length).round();
  }

  int get midOverall {
    return midfielders.isEmpty ? 0 : (midfielders.fold(0, (pre, curr) => pre + curr.overall) / midfielders.length).round();
  }

  int get defOverall {
    return defenders.isEmpty ? 0 : (defenders.fold(0, (pre, curr) => pre + curr.overall) / defenders.length).round();
  }

  int get overall {
    return ((attOverall + midOverall + defOverall) / 3).round();
  }

  List<Player> players = [];
  List<Player> get startPlayers {
    return players.where((player) => player.isStartingPlayer).toList();
  }

  Club.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    name = map['name'];
    nickName = map['nickName'];
    color = Color.fromRGBO(map['color']['red'], map['color']['green'], map['color']['blue'], 1);
    homeColor = Color.fromRGBO(map['homeColor']['red'], map['homeColor']['green'], map['homeColor']['blue'], 1);
    awayColor = Color.fromRGBO(map['awayColor']['red'], map['awayColor']['green'], map['awayColor']['blue'], 1);
    tactics = Tactics.fromJson(map['tactics']);
    clubRecord = (map['clubRecord'] as List).map((e) => ClubRecord.fromJson(e)).toList();
    won = map['won'];
    drawn = map['drawn'];
    lost = map['lost'];
    winStack = map['winStack'];
    noLoseStack = map['noLoseStack'];
    loseStack = map['loseStack'];
    noWinStack = map['noWinStack'];
    gf = map['gf'];
    ga = map['ga'];
    players = (map['players'] as List).map((e) => Player.fromJson(e)..team = this).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickName': nickName,
      'color': color.toJson(),
      'homeColor': homeColor.toJson(),
      'awayColor': awayColor.toJson(),
      'tactics': tactics.toJson(),
      'clubRecord': clubRecord.map((e) => e.toJson()).toList(),
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'winStack': winStack,
      'noLoseStack': noLoseStack,
      'loseStack': loseStack,
      'noWinStack': noWinStack,
      'gf': gf,
      'ga': ga,
      'players': players.map((e) => e.toJson()).toList(),
    };
  }
}

class Uniform {
  final Color mainColor;
  final Color pantColor;
  late final Color secondColor;
  final UniformType type;

  Uniform({
    required this.mainColor,
    Color? secondColor,
    required this.pantColor,
    required this.type,
  }) {
    this.secondColor = secondColor ?? mainColor;
  }
}

enum UniformType {
  plain,
  stripe,
  double,
}

class ClubRecord implements Jsonable {
  late final int season;
  late final int pts;
  late final int gf;
  late final int ga;
  late final int gd;
  late final int ranking;

  ClubRecord({required this.season, required this.pts, required this.gf, required this.ga, required this.gd, required this.ranking});

  ClubRecord.fromJson(Map<dynamic, dynamic> map) {
    season = map['season'];
    pts = map['pts'];
    gf = map['gf'];
    ga = map['ga'];
    gd = map['gd'];
    ranking = map['ranking'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'pts': pts,
      'gf': gf,
      'ga': ga,
      'gd': gd,
      'ranking': ranking,
    };
  }
}
