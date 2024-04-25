part of 'player.dart';

extension PlayerMove on Player {
  ready(Duration gameSpeed) {
    _streamController ??= StreamController<PlayerActEvent>.broadcast();
    updatePlaySpeed(gameSpeed);
  }

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

      if (lastAction != null) _streamController?.add(PlayerActEvent(player: this, action: lastAction!));
    });
  }

  gameEnd() async {
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
    _timer?.cancel();
    await _streamController?.close();
    _streamController = null;
    goal = 0;
    assist = 0;
    passSuccess = 0;
    passTry = 0;
    shooting = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
    _currentStamina = 100;
    resetPosXY();
    _growAfterPlay();
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
      bool isInHardBoundary = _checkBoundary(
        targetPos: newPos ?? player.posXY,
        otherPos: opponent.reversePosXy,
        sideBoundary: 10,
        frontBoundary: 20,
        backBoundary: -5,
        distance: 10,
      );

      bool isInSoftBoundary = _checkBoundary(
        targetPos: newPos ?? player.posXY,
        otherPos: opponent.reversePosXy,
        sideBoundary: 25,
        frontBoundary: 40,
        backBoundary: 5,
        distance: 25,
      );

      if (isInHardBoundary) {
        return prev * opponent.pressureStat / (player.evadePressStat + opponent.pressureStat);
      } else if (isInSoftBoundary) {
        double softPressure = (opponent.pressureStat / 3);
        return prev * softPressure / (player.evadePressStat + softPressure);
      } else {
        return prev;
      }
    });
  }

  double _getPassStat(PosXY targetPos) {
    double baselineStat = 0;
    if (targetPos.y > 180) {
      if (targetPos.distance(posXY) < 50) {
        baselineStat = sqrt(keyPassStat * shortPassStat);
      } else {
        baselineStat = sqrt(keyPassStat * longPassStat);
      }
    } else {
      if (targetPos.distance(posXY) < 50) {
        baselineStat = shortPassStat.toDouble();
      } else {
        baselineStat = longPassStat.toDouble();
      }
    }

    return baselineStat;
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

        double baselineStat = _getPassStat(player.posXY);

        if (distanceToPathRoute < baselineStat / 5) {
          canPass = false;
          break;
        }
      }

      if (canPass) {
        ///선수가 앞쪽에 있을 수록 매력도 상승
        player.attractive += player.posXY.y *
            (posXY.y > 100 ? 1 : 0.7) *
            switch (tactics?.attackLevel) {
              PlayLevel.max => 2,
              PlayLevel.hight => 1.7,
              PlayLevel.middle => 1,
              PlayLevel.low => 0.7,
              PlayLevel.min => 0.5,
              _ => 1,
            } *
            switch (team?.tactics.attackLevel) {
              PlayLevel.max => 2,
              PlayLevel.hight => 1.7,
              PlayLevel.middle => 1,
              PlayLevel.low => 0.7,
              PlayLevel.min => 0.5,
              _ => 1,
            };

        ///선수가 경기장 앞쪽 중앙에있을 수록 매력도 상승
        if (player.posXY.y > 150) {
          player.attractive += sqrt((player.posXY.x > 50 ? 100 - player.posXY.x : player.posXY.x) * player.posXY.y) * 0.35;
        }

        ///선수의 능력치가 높을 수록 매력도 상승
        player.attractive += player.overall * 0.15;

        ///선수가 위치한 압박 극복 점수 추가
        player.attractive += _getEvadePressurePoint(player, opponents);

        ///선수와의 거리가 가까울수록 매력도 상승 ~100점
        player.attractive += switch (player.posXY.distance(posXY)) {
              < 50 => 50,
              < 80 => 30,
              < 130 => 10,
              _ => 0,
            } *
            (posXY.y > 100 ? 0.5 : 1) *
            (posXY.y > 150 ? 0.5 : 1) *
            switch (tactics?.shortPassLevel) {
              PlayLevel.max => 2,
              PlayLevel.hight => 1.7,
              PlayLevel.middle => 1,
              PlayLevel.low => 0.7,
              PlayLevel.min => 0.5,
              _ => 1,
            } *
            switch (team?.tactics.shortPassLevel) {
              PlayLevel.max => 2,
              PlayLevel.hight => 1.7,
              PlayLevel.middle => 1,
              PlayLevel.low => 0.7,
              PlayLevel.min => 0.5,
              _ => 1,
            };

        if (posXY.y > 80 && player.role == PlayerRole.goalKeeper) {
          player.attractive -= 100;
        }
      }
    }

    players.sort((a, b) => b.attractive - a.attractive > 0 ? 1 : -1);

    return players.first;
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
        if (evadePressurePoint > evadePressStat) {
          _dribble(team, evadePressurePoint);
        } else {
          moveBack();
        }
        return;
      }

      ///압박감이 0 이하이면 _actPoint 증가
      if (evadePressurePoint > evadePressStat / 2) {
        _actPoint += judgementStat / 5;
      }

      /// actPoint가 10 이하인경우 대기만 가능
      if (_actPoint < 10) {
        _moveToBetterPos(opponentPlayers);
        return;
      } else if (_actPoint < 25) {
        ///탈압박이 불가능 할 경우
        if (evadePressurePoint < 30 && role != PlayerRole.goalKeeper) {
          ///본인 진영일 경우 일단 걷어내기
          if (posXY.y < 30) {
            _clearance(opponent: opponent, team: team);
          } else {
            moveBack();
          }

          ///탈압박이 가능한경우 일단 대기
        } else {
          _moveToBetterPos(opponentPlayers);
        }
        return;
      }

      if (position == Position.gk) {
        if (evadePressurePoint < 20 || visibleOurTeamPlayers.isEmpty) {
          _clearance(opponent: opponent, team: team);
        } else {
          Player target = _getMostAttractivePlayer(visibleOurTeamPlayers, opponentPlayers);
          _pass(target, team, opponentPlayers, fixture);
        }
      }

      ///상대 골대 중앙에있으면 슈팅
      if (posXY.y > 170 && (posXY.x > 35 && posXY.x < 65)) {
        _shoot(goalKeeper: goalKeeper, fixture: fixture, team: team, opponent: opponent, evadePressurePoint: evadePressurePoint);
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
              (25 - shootingStat ~/ 8))
          .length;

      double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

      if (opponentsNumNearShootRout < sqrt(shootingStat * 1.1) && distanceToGoalPost < midRangeShootStat / 3 && (posXY.x > 30 || posXY.x < 70)) {
        _shoot(
          fixture: fixture,
          team: team,
          opponent: opponent,
          evadePressurePoint: evadePressurePoint,
          goalKeeper: goalKeeper,
        );
        return;
      } else {
        bool canEvadePressureAndMoveFront = evadePressurePoint + evadePressStat > (200 - posXY.y) / 20;
        bool nearByGoalPost = (posXY.y > 170 && !(posXY.x > 35 && posXY.x < 65));

        if ((canEvadePressureAndMoveFront || nearByGoalPost)) {
          _dribble(team, evadePressurePoint);
        } else {
          Player target = _getMostAttractivePlayer(visibleOurTeamPlayers, opponentPlayers);

          _pass(target, team, opponentPlayers, fixture);
          return;
        }
      }
    } else {
      ///나와 포지션인 같은데 볼과 가까이있는 플레이어 리스트
      List<Player> nearBallPlayers = ourTeamPlayers
          .where((player) =>
              _checkBoundary(
                targetPos: ball.posXY,
                otherPos: player.posXY,
                frontBoundary: 50,
                backBoundary: -10,
                distance: 50,
              ) &&
              player.position == position)
          .toList();

      ///나와 포지션이 같은데 나보다 공과 가까이있는 플레이어
      int nearThanMePlayer = 0;

      for (var player in ourTeamPlayers) {
        if (!player.hasBall && (player.posXY.y < posXY.y) && player.position == position) nearThanMePlayer++;
      }

      bool isRearGuardPlayer = nearThanMePlayer <
          switch (role) {
            PlayerRole.defender => 1,
            PlayerRole.midfielder => 0,
            PlayerRole.forward => 0,
            _ => 0,
          };
      bool noBallAroundBall = nearBallPlayers.length <
          switch (role) {
            PlayerRole.defender => 1,
            PlayerRole.midfielder => 1,
            PlayerRole.forward => 0,
            _ => 0,
          };

      bool isBallBehind = posXY.y > ball.posXY.y;

      if (noBallAroundBall && isRearGuardPlayer && isBallBehind) {
        moveToBallForPass(ball.posXY);
        return;
      }

      if (evadePressurePoint == 100 && posXY.y > 130) {
        _moveToBetterPos(opponentPlayers);
      } else {
        List<Player> sortedPlayers = [...opponentPlayers];
        sortedPlayers.sort((a, b) => a.posXY.y - b.posXY.y > 0 ? 1 : -1);
        moveFront(sortedPlayers[1]);
      }
    }
  }

  ///TODO 삭제예정
  double get actPoint => _actPoint;

  defend({
    required ClubInFixture team,
    required ClubInFixture opponent,
    required Ball ball,
    required Fixture fixture,
  }) {
    bool isNotGoalKick = fixture.playerWithBall?.role != PlayerRole.goalKeeper;

    PosXY ballPos = PosXY(100 - ball.posXY.x, 200 - ball.posXY.y);
    bool canTackle = ballPos.distance(posXY) < 7 && isNotGoalKick && _actPoint > 60 && fixture.playerWithBall != null;

    int closerPlayerAtBall = team.club.players.where((player) => player.reversePosXy.distance(ball.posXY) < reversePosXy.distance(ball.posXY)).length;

    bool canPress =
        (30 + (tactics?.pressDistance ?? 0) + team.club.tactics.pressDistance > ballPos.distance(posXY)) && isNotGoalKick && !(ballPos.x == posXY.x && ballPos.y == posXY.y) && closerPlayerAtBall < 3;

    if (canTackle) {
      _tackle(fixture.playerWithBall!, team);
    } else if (canPress) {
      pressToBall(ball.posXY);
    } else {
      if (ball.posXY.distance(reversePosXy) > 50 && ballPos.y > posXY.y) {
        backToStartPos();
      } else {
        moveBack();
      }
    }
  }

  backToStartPos() {
    _move(targetPosXY: PosXY.random(startingPoxXY.x, startingPoxXY.y, 5));
  }

  _moveToBetterPos(List<Player> opponents) {
    lastAction = PlayerAction.none;

    List<PosXY> poss = List.generate(5, (index) => PosXY.random(posXY.x, posXY.y, 10));

    poss.sort((a, b) => _getEvadePressurePoint(this, opponents, a) - _getEvadePressurePoint(this, opponents, b) > 0 ? 1 : -1);

    _move(targetPosXY: poss.first);
  }

  moveFront(Player rearGuardPlayer) {
    lastAction = PlayerAction.move;
    _move(targetPosXY: PosXY.random(posXY.x, (posXY.y + maxDistance).clamp(0, rearGuardPlayer.reversePosXy.y), 3));
  }

  moveBack() {
    lastAction = PlayerAction.move;

    _move(targetPosXY: PosXY.random(posXY.x, posXY.y - maxDistance, 2));
  }

  _dribble(ClubInFixture team, double evadePressurePoint) {
    if (evadePressurePoint < 20) {
      lastAction = PlayerAction.dribble;
      dribbleSuccess++;
      team.dribble++;
    }
    double addX = (posXY.x < 50 ? 1 : -1) * (posXY.y > 170 ? maxDistance : 0);
    double addY = posXY.y <= 170 ? maxDistance : 0;

    _move(targetPosXY: PosXY.random(posXY.x + addX, posXY.y + addY, 2));
  }

  turn(PosXY targetPosXY) {
    double radian = atan2(targetPosXY.y - posXY.y, targetPosXY.x - posXY.x);

    rotateDegree = radian;
    _streamController?.add(PlayerActEvent(player: this, action: PlayerAction.none));
  }

  _clearance({
    required ClubInFixture team,
    required ClubInFixture opponent,
  }) {
    Player receivedPlayer = _findClosetPlayer(
        PosXY(
          R().getDouble(min: 0, max: 100),
          R().getDouble(min: 150, max: 200),
        ),
        [...team.club.players],
        [...opponent.club.players]);
    hasBall = false;
    receivedPlayer.hasBall = true;
  }

  Player _findClosetPlayer(PosXY targetPos, List<Player> team, List<Player> opponents) {
    team.sort((a, b) => a.posXY.distance(targetPos) - b.posXY.distance(targetPos) > 0 ? 1 : -1);
    opponents.sort((a, b) => a.reversePosXy.distance(targetPos) - b.reversePosXy.distance(targetPos) > 0 ? 1 : -1);

    return team.first.posXY.distance(targetPos) < opponents.first.reversePosXy.distance(targetPos) ? team.first : opponents.first;
  }

  _pass(Player target, ClubInFixture team, List<Player> opponents, Fixture fixture) async {
    passTry++;
    turn(target.posXY);
    lastAction = PlayerAction.pass;

    ///현재 선수 위치와 패스받으려는 선수 위치의 차이 클수록 정확도 하락 최대 20
    double passDistancePenalty = target.posXY.distance(posXY);

    double baselineStat = _getPassStat(target.posXY);

    ///최종 볼 정확도( 낮을수록 좋음 최소0 최대 10)
    double ballLandingAccuracy = max(0, passDistancePenalty * 0.4 - baselineStat);

    PosXY ballLandingPos = PosXY.random(target.posXY.x, target.posXY.y, ballLandingAccuracy);

    hasBall = false;

    Player receivedPlayer = _findClosetPlayer(ballLandingPos, [target], [...opponents]);
    if (receivedPlayer.id == target.id) {
      passSuccess++;
      target.passedPlayer = this;
      target.hasBall = true;
      team.pass += 1;
    } else {
      receivedPlayer.hasBall = true;
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

    double stat = distanceToGoalPost < 20 ? shootingStat.toDouble() : shootingStat * ((100 - distanceToGoalPost) / 100) + midRangeShootStat * (distanceToGoalPost / 100);

    double finalShootStat = pow(stat * 0.75 + evadePressurePoint, 0.15 + R().getDouble(max: 0.95)).toDouble();

    double finalKeepingStat = goalKeeper.keepingStat * R().getDouble(min: 0.85, max: 1.65);

    if (finalShootStat > finalKeepingStat) {
      goal++;
      _streamController?.add(PlayerActEvent(player: this, action: PlayerAction.goal));
      if (passedPlayer != null) _streamController?.add(PlayerActEvent(player: passedPlayer!, action: PlayerAction.assist));

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

    ///태클을 할 타겟과의 거리 (0~7)
    double distanceToTarget = targetPlayer.reversePosXy.distance(posXY);

    ///태클 보너스(0~7)
    double tackleBonus = R().getDouble(max: 1.9);

    double tackleSuccessPercent = tackleStat * tackleBonus / (tackleStat * tackleBonus + targetPlayer.evadePressStat * distanceToTarget);

    if (tackleSuccessPercent > R().getDouble(max: 1)) {
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

    PosXY wantPos = PosXY(posXY.x + travelX, posXY.y + travelY);

    if (!hasBall) {
      ///새로 이동하는곳이 기존 위치보다 스타팅 포인트에서 더 멀리 떨어진 곳이면 저항치 증가
      double resistanceXByStarting = wantPos.distance(startingPoxXY) > posXY.distance(startingPoxXY) ? (200 - wantPos.distance(startingPoxXY)) / 200 : 1;

      ///x축 이동 저항 ( 0 ~ 1)
      double resistanceXByFreedom = (100 - (wantPos.x > startingPoxXY.x ? _rightFreedom : _leftFreedom)) / 100;

      double resistanceX = resistanceXByFreedom * resistanceXByStarting;

      ///y축 이동 저항 ( 0 ~ 1)
      double resistanceYyFreedom = (100 - (wantPos.y > startingPoxXY.y ? _forwardFreedom : _backwardFreedom)) / 100;

      double resistanceY = resistanceYyFreedom * resistanceXByStarting;

      ///최종 이동할 좌표
      wantPos = PosXY(posXY.x + travelX * resistanceX, posXY.y + travelY * resistanceY);
    }

    ///실제 이동 거리
    double moveDistance = wantPos.distance(posXY);

    ///TODO: 체력 감소 로직 추후 구체화
    if (_currentStamina > 30) {
      _currentStamina -= moveDistance / stat.stamina;
    } else {
      _currentStamina *= 0.95;
    }

    if (moveDistance > 5) turn(wantPos);
    posXY = wantPos;
  }
}
