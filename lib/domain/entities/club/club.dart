// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:soccer_simulator/domain/entities/club/club_season_stat.dart';
import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
import 'package:soccer_simulator/domain/enum/position.enum.dart';

class Club {
  Club({
    required this.id,
    required this.national,
    required this.name,
    required this.nickName,
    required this.homeColor,
    required this.awayColor,
    required this.tactics,
    required this.clubSeasonStats,
    required this.winStack,
    required this.noLoseStack,
    required this.loseStack,
    required this.noWinStack,
    required this.players,
  });

  final int id;

  ///소속 국가
  final National national;

  ///팀 이름
  final String name;

  ///팀 줄임말
  final String nickName;

  ///홈 유니폼 컬러
  final Color homeColor;

  ///어웨이 유니폼 컬러
  final Color awayColor;

  ///전술
  Tactics tactics;

  ///클럽의 시즌 기록들
  List<ClubSeasonStat> clubSeasonStats = [];

  ///이번 시즌 기록
  ClubSeasonStat get currentSeasonStat => clubSeasonStats.last;

  /// 연승
  int winStack;

  ///연속 무패
  int noLoseStack;

  ///연패
  int loseStack;

  ///연속 무승
  int noWinStack;

  ///클럽에 속한 선수
  List<Player> players = [];

  ///스타팅 멤버
  List<Player> get startingPlayers {
    return players.where((player) => player.isStartingPlayer).toList();
  }

  startNewSeason(int season, int ranking) {
    ///TODO
  }

  win() {
    currentSeasonStat.win();
    winStack++;
    noLoseStack++;
    loseStack = 0;
    noWinStack = 0;
  }

  lose() {
    currentSeasonStat.lose();
    noWinStack++;
    loseStack++;
    winStack = 0;
    noLoseStack = 0;
  }

  draw() {
    currentSeasonStat.draw();
    noWinStack++;
    noLoseStack++;
    winStack = 0;
    loseStack = 0;
  }

  List<Player> get forwards => startingPlayers.where((player) => player.role == PlayerRole.forward).toList();
  List<Player> get midfielders => startingPlayers.where((player) => player.role == PlayerRole.midfielder).toList();
  List<Player> get defenders => startingPlayers.where((player) => player.role == PlayerRole.defender || player.role == PlayerRole.goalKeeper).toList();

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
}

// class Uniform {
//   final Color mainColor;
//   final Color pantColor;
//   late final Color secondColor;
//   final UniformType type;

//   Uniform({
//     required this.mainColor,
//     Color? secondColor,
//     required this.pantColor,
//     required this.type,
//   }) {
//     this.secondColor = secondColor ?? mainColor;
//   }
// }

// enum UniformType {
//   plain,
//   stripe,
//   double,
// }
