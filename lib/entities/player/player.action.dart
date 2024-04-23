part of 'player.dart';

extension PlayerMove on Player {
  gameStart({
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required bool isHome,
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(playSpeed, (timer) async {
      playTime = fixture.playTime;
      bool teamHasBall = team.club.startPlayers.where((player) => player.hasBall).isNotEmpty;
      lastAction = null;

      /// 판단력/5 만큼 행동 포인트 적립
      _actPoint += judgementStat / 10;
      if (teamHasBall) {
        attack(team: team, opponent: opposite, ball: ball, fixture: fixture);
      } else {
        defend(team: team, opponent: opposite, ball: ball, fixture: fixture);
      }

      if (lastAction != null) _streamController.add(PlayerActEvent(player: this, action: lastAction!));
    });
  }

  gameEnd() {
    gameRecord.add(PlayerGameRecord(
      goal: goal,
      assist: assist,
      passSuccess: passSuccess,
      pass: passTry,
      shooting: shooting,
      defSuccess: defSuccess,
      saveSuccess: saveSuccess,
      dribbleSuccess: dribbleSuccess,
    ));
    goal = 0;
    assist = 0;
    passSuccess = 0;
    shooting = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
    _currentStamina = 100;
    resetPosXY();
    _growAfterPlay();
    _timer?.cancel();
  }

  ///상대방의 위치가 특정 포지션을 압박할 수 있는지를 리턴해주는 함수
  bool _isCanPressure(PosXY targetPos, PosXY opponentPos) {
    bool isClosePosX = opponentPos.x < targetPos.x + 20 && opponentPos.x > targetPos.x - 20;
    bool isClosePosY = opponentPos.y > targetPos.y && opponentPos.y - 5 < targetPos.y + 25;
    return isClosePosX && isClosePosY;
  }

  bool _checkBoundary({
    required PosXY targetPos,
    required PosXY otherPos,
    double? sideBoundary,
    double? frontBoundary,
    double? backBoundary,
    double? distance,
  }) {
    bool isInSideBoundary = sideBoundary == null ? true : (targetPos.x - otherPos.x).abs() <= sideBoundary;
    bool isInFrontBoundary = frontBoundary == null ? true : otherPos.y - targetPos.y <= frontBoundary;
    bool isInBackBoundary = backBoundary == null ? true : targetPos.y - otherPos.y <= backBoundary;
    bool isInDistance = distance == null ? true : targetPos.distance(otherPos) <= distance;
    return isInSideBoundary && isInDistance && isInFrontBoundary && isInBackBoundary;
  }

  ///선수의 탈압박 점수를 계산하는 함수 ~100점
  double _getEvadePressurePoint(Player player, List<Player> opponents, [PosXY? newPos]) {
    return opponents.fold(100, (prev, opponent) {
      bool isInBoundary = _checkBoundary(
        targetPos: newPos ?? player.posXY,
        otherPos: opponent.reversePosXy,
        sideBoundary: 20,
        frontBoundary: 35,
        backBoundary: 5,
        distance: 20,
      );

      if (isInBoundary) {
        return prev * player.pressureStat / (player.evadePressStat + opponent.pressureStat);
      } else {
        return prev;
      }
    });
  }

  Player _getMostAttractivePlayer(List<Player> players, List<Player> opponents) {
    ///활용 가능한 선수들의 매력도를 판단
    for (var player in players) {
      bool canPass = true;

      ///매력도를 0으로 초기화
      player.attractive = 0;

      ///해당 선수한테 패스하는 길목에 상대편 선수가 있다면 패스 시도 불가능
      for (var opponent in opponents) {
        ///패스 길과 해당 선수와의 거리
        double distanceToPathRoute = M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: player.posXY, point: opponent.reversePosXy);

        double baselineStat = 0;
        if (player.posXY.y > 180) {
          if (player.posXY.distance(posXY) < 50) {
            baselineStat = sqrt(keyPassStat * shortPassStat);
          } else {
            baselineStat = sqrt(keyPassStat * longPassStat);
          }
        } else {
          if (player.posXY.distance(posXY) < 50) {
            baselineStat = shortPassStat.toDouble();
          } else {
            baselineStat = longPassStat.toDouble();
          }
        }

        if (distanceToPathRoute < baselineStat / 10) {
          canPass = false;
          break;
        }
      }

      if (canPass) {
        ///선수가 앞쪽에 있을 수록 매력도 상승
        player.attractive += sqrt(player.posXY.y * posXY.y) / 2;
        // print('선수가 앞쪽에 있을 수록 매력도 상승${player.attractive}');

        ///선수의 능력치가 높을 수록 매력도 상승
        player.attractive += player.overall / 5;
        // print('선수의 능력치가 높을 수록 매력도 상승${player.attractive}');

        ///선수가 위치한 압박 극복 점수 추가
        player.attractive += _getEvadePressurePoint(player, opponents);

        ///선수와의 거리가 가까울수록 매력도 상승 ~100점
        player.attractive += switch (player.posXY.distance(posXY)) {
              < 30 => 50,
              < 60 => 30,
              < 100 => 10,
              _ => 0,
            } *
            (posXY.y > 100 ? 0.2 : 1);

        // print('선수와의 거리가 가까울수록 매력도 상승${player.attractive}');
      }
    }

    players.sort((a, b) => b.attractive - a.attractive > 0 ? 1 : -1);

    return players.first;
  }

  _getDefensePoint({required PosXY target, required PosXY pressurePlayer, required int stat}) {
    double distanceToOpponent = target.distance(pressurePlayer);
    return pow(max(0, stat - pow(distanceToOpponent, 1.3)), 1.3);
  }

  attack({
    required ClubInFixture team,
    required ClubInFixture opponent,
    required Ball ball,
    required Fixture fixture,
  }) {
    ///우리팀 선수들
    List<Player> ourTeamPlayers = [...team.club.players.where((p) => p.id != id)];

    ///상대팀 선수들
    List<Player> opponentPlayers = opponent.club.players;

    ///탈압박 점수
    double evadePressurePoint = _getEvadePressurePoint(this, opponentPlayers);

    ///상대선수 골키퍼
    Player goalKeeper = opponentPlayers.firstWhere(
      (player) => player.role == PlayerRole.goalKeeper,
    );

    ///현재 내가 공을 잡은 상태인 경우
    if (hasBall) {
      ///압박을 고려한 식별 가능한 거리
      double canVisibleDistance = visionStat + evadePressurePoint;

      ///내가 활용 가능한 우리팀 선수들: canVisibleDistance 이내
      List<Player> visibleOurTeamPlayers = ourTeamPlayers.where((teamPlayer) => teamPlayer.posXY.distance(posXY) < canVisibleDistance).toList();

      ///주변에 활용 가능한 선수가 안보일 때
      if (visibleOurTeamPlayers.isEmpty) {
        if (evadePressurePoint > 30) {
          dribble(team);
        } else {
          moveBack();
        }
        return;
      }

      ///압박감이 0 이하이면 _actPoint 증가
      if (evadePressurePoint < 30) {
        _actPoint += judgementStat / 5;
      }

      /// actPoint가 10 이하인경우 대기만 가능
      if (_actPoint < 10) {
        stay();
        return;
      } else if (_actPoint < 25) {
        ///탈압박이 불가능 할 경우
        if (evadePressurePoint < 30 && role != PlayerRole.goalKeeper && posXY.y < 175) {
          List<Player> behindPlayers = ourTeamPlayers.where((player) => player.posXY.y < posXY.y + 5).toList();
          Player target = _getMostAttractivePlayer(behindPlayers, opponentPlayers);
          List<Player> nearOpponentAtTarget = opponentPlayers.where((opponent) => opponent.posXY.distance(target.reversePosXy) < 15).toList();
          pass(target, team, nearOpponentAtTarget, fixture);

          ///탈압박이 가능한경우 일단 대기
        } else {
          stay();
        }
        return;
      }

      ///상대 골대 중앙에있으면 슈팅
      if (posXY.y > 175 && (posXY.x > 35 || posXY.x < 65)) {
        _shoot(goalKeeper: goalKeeper, fixture: fixture, team: team, opponent: opponent, evadePressurePoint: evadePressurePoint);
        return;
      }

      if (evadePressurePoint > 100) {
        dribble(team);
        return;
      }

      ///슛을 했을 때 일정경로 이내에 있는 선수의 수 - 슛스텟이 높아질수록 정교해짐
      int opponentsNumNearShootRout = fixture.allPlayers
          .where((opponent) =>
              M().getDistanceFromPointToLine(
                linePoint1: posXY,
                linePoint2: goalKeeper.reversePosXy,
                point: opponent.reversePosXy,
              ) <
              (25 - shootingStat ~/ 10))
          .length;

      double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

      if (opponentsNumNearShootRout < shootingStat ~/ 17 && distanceToGoalPost < midRangeShootStat && (posXY.x > 30 || posXY.x < 70)) {
        _shoot(
            fixture: fixture,
            team: team,
            opponent: opponent,
            evadePressurePoint: evadePressurePoint,
            goalKeeper: opponentPlayers.firstWhere(
              (player) => player.role == PlayerRole.goalKeeper,
            ));
        return;
      } else {
        Player target = _getMostAttractivePlayer(visibleOurTeamPlayers, opponentPlayers);
        List<Player> nearOpponentAtTarget = opponentPlayers.where((opponent) => opponent.posXY.distance(target.reversePosXy) < 15).toList();

        pass(target, team, nearOpponentAtTarget, fixture);
        return;
      }
    } else {
      List<Player> nearBallPlayers = ourTeamPlayers
          .where((player) => _checkBoundary(
                targetPos: ball.posXY,
                otherPos: player.posXY,
                frontBoundary: 50,
                backBoundary: -10,
                distance: 50,
              ))
          .toList();

      bool isRearGuardPlayer = ourTeamPlayers.where((player) => !player.hasBall && (player.posXY.y < posXY.y)).isEmpty;
      if (nearBallPlayers.isEmpty && isRearGuardPlayer) {
        moveToBallForPass(ball.posXY);
        return;
      }

      if (evadePressurePoint == 100 && posXY.y > 130) {
        stay();
      } else {
        List<Player> sortedPlayers = [...opponentPlayers];
        sortedPlayers.sort((a, b) => a.posXY.y - b.posXY.y > 0 ? 1 : -1);
        moveFront(sortedPlayers[1]);
      }
    }
  }

  defend({
    required ClubInFixture team,
    required ClubInFixture opponent,
    required Ball ball,
    required Fixture fixture,
  }) {
    bool isNotGoalKick = fixture.playerWithBall?.role != PlayerRole.goalKeeper;

    PosXY ballPos = PosXY(100 - ball.posXY.x, 200 - ball.posXY.y);
    bool canTackle = ballPos.distance(posXY) < 8 && isNotGoalKick && _actPoint > 30 && fixture.playerWithBall != null;

    int closerPlayerAtBall = team.club.players.where((player) => player.reversePosXy.distance(ball.posXY) < reversePosXy.distance(ball.posXY)).length;

    bool canPress = ((tactics?.pressDistance ?? 0) + team.club.tactics.pressDistance > ballPos.distance(posXY)) &&
        isNotGoalKick &&
        !(ballPos.x == posXY.x && ballPos.y == posXY.y) &&
        _actPoint > 10 &&
        closerPlayerAtBall < 3;

    if (canTackle) {
      _tackle(fixture.playerWithBall!, team);
    } else {
      if (canPress) {
        pressToBall(ball.posXY);
      } else {
        moveBack();
      }
    }
  }

  stay() {
    lastAction = PlayerAction.none;
    _move(targetPosXY: PosXY.random(posXY.x, posXY.y, 6));
  }

  moveFront(Player rearGuardPlayer) {
    lastAction = PlayerAction.move;
    _move(targetPosXY: PosXY.random(posXY.x, (posXY.y + maxDistance).clamp(0, rearGuardPlayer.reversePosXy.y), 3));
  }

  moveBack() {
    lastAction = PlayerAction.move;
    double backDistance = -1 * min(10, (posXY.y - startingPoxXY.y * 0.8) * 0.2);

    _move(targetPosXY: PosXY.random(posXY.x, posXY.y + backDistance, 2));
  }

  dribble(ClubInFixture team) {
    lastAction = PlayerAction.dribble;
    double addX = posXY.y > 165 ? maxDistance : 0;
    double addY = posXY.y <= 165 ? maxDistance : 0;

    _move(targetPosXY: PosXY.random(posXY.x + addX, posXY.y + addY, 2));
    dribbleSuccess++;
    team.dribble++;
  }

  turn(PosXY targetPosXY) {
    double radian = atan2(targetPosXY.y - posXY.y, targetPosXY.x - posXY.x);
    // radian = radian > pi ? 2 * pi - radian : radian;

    rotateDegree = radian;
    _streamController.add(PlayerActEvent(player: this, action: PlayerAction.none));
  }

  pass(Player target, ClubInFixture team, List<Player> nearOpponentAtTarget, Fixture fixture) async {
    passTry++;
    turn(target.posXY);
    lastAction = PlayerAction.pass;

    ///현재 선수 위치와 패스받으려는 선수 위치의 차이 클수록 정확도 하락 최대 20
    double passDistancePenalty = min(20, target.posXY.distance(posXY) / 3);

    ///패스 정확도 능력치 최대 10
    double passAbilityAdvantage = min(10, overall / 20);

    ///최종 볼 정확도( 낮을수록 좋음 최소0 최대 10)
    double ballLandingAccuracy = max(0, passDistancePenalty - passAbilityAdvantage);

    PosXY ballLandingPos = PosXY(
      (target.posXY.x + R().getDouble(min: 2, max: 3 + ballLandingAccuracy)).clamp(0, 100),
      (target.posXY.y + R().getDouble(min: 2, max: 3 + ballLandingAccuracy)).clamp(0, 200),
    );

    nearOpponentAtTarget.sort((a, b) => a.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) - b.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) > 0 ? 1 : -1);

    double targetDistance = target.posXY.distance(ballLandingPos);
    hasBall = false;
    if (nearOpponentAtTarget.isEmpty || targetDistance < nearOpponentAtTarget.first.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y))) {
      passSuccess++;
      target.passedPlayer = this;
      target.hasBall = true;
      team.pass += 1;
    } else {
      nearOpponentAtTarget.first.hasBall = true;
    }
  }

  _shoot({
    required Player goalKeeper,
    required Fixture fixture,
    required double evadePressurePoint,
    required ClubInFixture team,
    required ClubInFixture opponent,
  }) {
    lastAction = PlayerAction.shoot;
    hasBall = false;
    goalKeeper.hasBall = true;
    team.shoot += 1;
    shooting++;

    double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

    if ((pow(shootingStat, 1.45 + R().getDouble(max: 0.75))) > goalKeeper.keepingStat * distanceToGoalPost) {
      goal++;
      _streamController.add(PlayerActEvent(player: this, action: PlayerAction.goal));
      if (passedPlayer != null) _streamController.add(PlayerActEvent(player: passedPlayer!, action: PlayerAction.assist));
      fixture.scored(
        scoredClub: team,
        concedeClub: opponent,
        scoredPlayer: this,
        assistPlayer: passedPlayer,
      );
    }
  }

  _tackle(Player targetPlayer, ClubInFixture team) {
    _actPoint = 0;
    if (pow(tackleStat, 1.7) / (targetPlayer.reversePosXy.distance(posXY)) > pow(targetPlayer.evadePressStat, 1.35)) {
      lastAction = PlayerAction.tackle;
      defSuccess++;
      targetPlayer.hasBall = false;
      hasBall = true;
      team.tackle += 1;
    } else {}
  }

  moveToBallForPass(PosXY ballPosXY) {
    double ballPosX = ballPosXY.x;
    double ballPosY = min(200, ballPosXY.y + 20);
    lastAction = PlayerAction.keeping;

    _move(targetPosXY: PosXY(ballPosX, ballPosY));
  }

  pressToBall(PosXY ballPosXY) {
    double ballPosX = 100 - ballPosXY.x;
    double ballPosY = max(0, 200 - ballPosXY.y - 10);
    lastAction = PlayerAction.press;

    _move(targetPosXY: PosXY(ballPosX, ballPosY));
  }

  _move({required PosXY targetPosXY}) {
    /// x,y 좌표의 차이를 각각 구하기
    double deltaX = (targetPosXY.x - posXY.x);
    double deltaY = (targetPosXY.y - posXY.y);

    /// 해당 타깃과의 거리 구하기
    double distanceToTarget = max(1, PosXY(targetPosXY.x, targetPosXY.y).distance(posXY));

    /// 이동할 수 있는 최대 거리 구하기
    double distanceCanForward = min(distanceToTarget, maxDistance - (hasBall ? 3 : 0));

    /// sine,cosine값 구하기
    double sine = deltaY / distanceToTarget;
    double cosine = deltaX / distanceToTarget;

    /// x,y 축으로의 실제 이동거리
    double travelX = distanceCanForward * cosine;
    double travelY = distanceCanForward * sine;

    ///최종 이동할 좌표
    PosXY newPos = PosXY((posXY.x + travelX).clamp(_posXMinBoundary, _posXMaxBoundary), (posXY.y + travelY).clamp(_posYMinBoundary, _posYMaxBoundary));

    ///실제 이동 거리
    double moveDistance = newPos.distance(posXY);

    ///TODO: 체력 감소 로직 추후 구체화
    if (_currentStamina > 30) {
      _currentStamina -= moveDistance / stat.stamina;
    } else {
      _currentStamina *= 0.95;
    }

    if (moveDistance > 5) turn(newPos);
    posXY = newPos;
  }
}
