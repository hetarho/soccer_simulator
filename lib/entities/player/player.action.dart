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

  Player getMostAttractivePlayer(List<Player> players, List<Player> opponentPlayers) {
    ///활용 가능한 선수들의 매력도를 판단
    List<Player> judgedTeamPlayer = players.map((player) {
      ///매력도를 0으로 초기화
      player.attractive = 0;

      ///선수가 앞쪽에 있을 수록 매력도 상승
      player.attractive += (pow(player.posXY.y, 1.4) + pow(posXY.y, 1.9));
      // print('선수가 앞쪽에 있을 수록 매력도 상승${player.attractive}');

      ///선수의 능력치가 높을 수록 매력도 상승
      player.attractive += player.overall;
      // print('선수의 능력치가 높을 수록 매력도 상승${player.attractive}');

      ///선수와의 거리가 가까울수록 매력도 상승
      player.attractive += pow(20 / player.posXY.distance(posXY), 2);
      // print('선수와의 거리가 가까울수록 매력도 상승${player.attractive}');

      ///상대편 선수들과 해당 선수의 거리를 비교
      for (var opponent in opponentPlayers) {
        ///해당 선수에게 패스시 패스길과 적의 거리
        double distanceToPathRoute = M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: player.posXY, point: opponent.reversePosXy);

        ///해당 선수에게 패스시 패스길과 특정 거리 이내 매력도 하락
        double unit = 15.0;
        if (distanceToPathRoute < unit) {
          player.attractive -= distanceToPathRoute * unit;
        }
        // print('당 선수에게 패스시 패스길과 특정 거리 이내 매력도 하락${player.attractive}');

        ///해당 선수에게 압박 가능한 선수들이 많을수록 매력도 하락
        if (_isCanPressure(player.posXY, opponent.reversePosXy)) {
          player.attractive -= _getPressure(target: player.posXY, pressurePlayer: opponent.reversePosXy, pressureStat: opponent.pressureStat);
        }
        // print('해당 선수에게 압박 가능한 선수들이 많을수록 매력도 하락${player.attractive}');
      }

      return player;
    }).toList();

    judgedTeamPlayer.sort((a, b) => b.attractive - a.attractive > 0 ? 1 : -1);

    return judgedTeamPlayer.first;
  }

  _getPressure({required PosXY target, required PosXY pressurePlayer, required int pressureStat}) {
    double distanceToOpponent = target.distance(pressurePlayer);
    return pow(max(0, pressureStat - pow(distanceToOpponent, 1.3)), 1.3);
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

    ///나에게 압박을 주는 상대팀 선수들
    List<Player> pressureOpponentPlayers = opponentPlayers.where((opponent) => _isCanPressure(posXY, opponent.reversePosXy)).toList();

    ///선수가 느끼는 압박감
    double pressureIntensity = pressureOpponentPlayers.fold(0.0, (prev, opponent) {
      return _getPressure(target: posXY, pressurePlayer: opponent.reversePosXy, pressureStat: opponent.pressureStat);
    });

    ///상대선수 골키퍼
    Player goalKeeper = opponentPlayers.firstWhere(
      (player) => player.role == PlayerRole.goalKeeper,
    );

    ///현재 내가 공을 잡은 상태인 경우
    if (hasBall) {
      ///압박을 고려한 식별 가능한 거리
      double canVisibleDistance = visionStat - min(0, pressureIntensity - evadePressStat);

      ///내가 활용 가능한 우리팀 선수들: canVisibleDistance 이내
      List<Player> visibleOurTeamPlayers = ourTeamPlayers.where((teamPlayer) => teamPlayer.posXY.distance(posXY) < canVisibleDistance).toList();

      ///주변에 활용 가능한 선수가 안보일 때
      if (visibleOurTeamPlayers.isEmpty) {
        ///압박감이 0보다 낮을 때
        if (pressureIntensity - evadePressStat < 0) {
          dribble(team);
        } else {
          moveBack();
        }
        return;
      }

      ///압박감이 0 이하이면 _actPoint 증가
      if (pressureIntensity - evadePressStat < 0) {
        _actPoint += judgementStat / 5;
      }

      /// actPoint가 10 이하인경우 대기만 가능
      if (_actPoint < 10) {
        stay();
        return;
      } else if (_actPoint < 25) {
        ///탈압박이 불가능 할 경우
        if (pressureIntensity - evadePressStat > 0 && role != PlayerRole.goalKeeper && posXY.y < 175) {
          List<Player> behindPlayers = ourTeamPlayers.where((player) => player.posXY.y < posXY.y + 5).toList();
          Player target = getMostAttractivePlayer(behindPlayers, opponentPlayers);
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
        _shoot(goalKeeper: goalKeeper, fixture: fixture, team: team, opponent: opponent, pressureOpponentPlayers: pressureOpponentPlayers);
        return;
      }

      //압박감이 0이하인데 포지션이 특정 포지션 일 경우
      if (pressureIntensity < evadePressStat / 2 &&
          [
            Position.st,
            Position.cf,
            Position.lf,
            Position.rf,
            Position.lw,
            Position.rw,
            Position.lm,
            Position.rm,
            Position.am,
            Position.lb,
            Position.rb,
          ].contains(position)) {
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
              (20 - shootingStat ~/ 10))
          .length;

      if (opponentsNumNearShootRout < 3 + midRangeShootStat ~/ 20) {
        _shoot(
            fixture: fixture,
            team: team,
            opponent: opponent,
            pressureOpponentPlayers: pressureOpponentPlayers,
            goalKeeper: opponentPlayers.firstWhere(
              (player) => player.role == PlayerRole.goalKeeper,
            ));
        return;
      } else {
        Player target = getMostAttractivePlayer(visibleOurTeamPlayers, opponentPlayers);
        List<Player> nearOpponentAtTarget = opponentPlayers.where((opponent) => opponent.posXY.distance(target.reversePosXy) < 15).toList();

        pass(target, team, nearOpponentAtTarget, fixture);
        return;
      }
    } else {
      List<Player> nearBallPlayers = team.club.players.where((player) => player.posXY.distance(ball.posXY) < 50).toList();
      if (nearBallPlayers.isEmpty) {
        moveToBall(ball.posXY);
        return;
      }

      if (pressureIntensity < 30 && posXY.y > 80) {
        stay();
      } else {
        moveFront();
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
    bool canTackle = ballPos.distance(posXY) < 10 && isNotGoalKick && _actPoint > 50 && fixture.playerWithBall != null;

    bool canPress = ((tactics?.pressDistance ?? 0) + team.club.tactics.pressDistance > ballPos.distance(posXY)) && isNotGoalKick && !(ballPos.x == posXY.x && ballPos.y == posXY.y) && _actPoint > 10;

    if (canTackle) {
      _tackle(fixture.playerWithBall!, team);
    } else {
      if (canPress) {
        moveToBall(ball.posXY);
      } else {
        moveBack();
      }
    }
  }

  stay() {
    lastAction = PlayerAction.none;
    _move(targetPosXY: PosXY.random(posXY.x, posXY.y, 3));
  }

  moveFront() {
    lastAction = PlayerAction.none;
    double frontDistance = switch (role) {
      PlayerRole.forward => 10,
      PlayerRole.midfielder => 8,
      PlayerRole.defender => 4,
      _ => 0,
    };
    _move(targetPosXY: PosXY.random(posXY.x, posXY.y + frontDistance, 3));
  }

  moveBack() {
    lastAction = PlayerAction.none;
    double backDistance = -1 * min(10, (posXY.y - startingPoxXY.y * 0.8) * 0.2);

    _move(targetPosXY: PosXY.random(posXY.x, posXY.y + backDistance, 2));
  }

  dribble(ClubInFixture team) {
    lastAction = PlayerAction.dribble;
    double addX = posXY.y > 165 ? maxDistance : 0;
    double addY = posXY.y <= 165 ? maxDistance : 0;

    _move(targetPosXY: PosXY.random(posXY.x + addX, posXY.y + addY, 5));
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
    required List<Player> pressureOpponentPlayers,
    required ClubInFixture team,
    required ClubInFixture opponent,
  }) {
    lastAction = PlayerAction.shoot;
    hasBall = false;
    goalKeeper.hasBall = true;
    team.shoot += 1;
    shooting++;

    double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

    double pressureIntensity = pressureOpponentPlayers.fold(0.0, (prev, opponent) {
      return _getPressure(target: posXY, pressurePlayer: opponent.reversePosXy, pressureStat: opponent.pressureStat);
    });

    if ((pow(shootingStat, 0.8 + R().getDouble(max: 1))) > goalKeeper.keepingStat * distanceToGoalPost * min(1, pressureIntensity)) {
      goal++;
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
    double pressurePower = _getPressure(target: targetPlayer.reversePosXy, pressurePlayer: posXY, pressureStat: pressureStat);
    if (((tackleStat * pressurePower)) > pow(targetPlayer.evadePressStat, 2.2)) {
      lastAction = PlayerAction.tackle;
      defSuccess++;
      targetPlayer.hasBall = false;
      hasBall = true;
      team.tackle += 1;
    } else {}
  }

  moveToBall(PosXY ballPosXY) {
    double ballPosX = 100 - ballPosXY.x;
    double ballPosY = 200 - ballPosXY.y;
    lastAction = PlayerAction.none;

    _move(targetPosXY: PosXY(ballPosX, ballPosY));
  }

  _move({required PosXY targetPosXY}) {
    /// x,y 좌표의 차이를 각각 구하기
    double deltaX = (targetPosXY.x - posXY.x);
    double deltaY = (targetPosXY.y - posXY.y);

    /// 해당 타깃과의 거리 구하기
    double distanceToTarget = PosXY(targetPosXY.x, targetPosXY.y).distance(posXY);

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
