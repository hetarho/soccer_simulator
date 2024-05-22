part of 'player.dart';

extension PlayerMove on Player {
  ready(Duration gameSpeed) {
    _streamController ??= StreamController<PlayerActEvent>.broadcast();
    updatePlaySpeed(gameSpeed);
  }

  gameStart({
    required Fixture fixture,
  }) {
    _currentFixture = fixture;
    _play();
  }

  _pause() async {
    _timer?.cancel();

    double judgementBonus = 50 / judgementStat;

    if (_currentFixture.isGoalKick) await Future.delayed(Duration(milliseconds: playSpeed.inMilliseconds * 3));

    if (_currentFixture.ball.isMoving) {
      await Future.delayed(Duration(milliseconds: (playSpeed.inMilliseconds * _currentFixture.ball.ballSpeed * judgementBonus).round()));
      _currentFixture.ball.isMoving = false;
    } else if (!hasBall) {
      await Future.delayed(Duration(milliseconds: (playSpeed.inMilliseconds * judgementBonus * 2).round()));
    }

    _play();
  }

  _play() {
    _timer?.cancel();
    _timer = Timer.periodic(playSpeed, (timer) async {
      playTime = _currentFixture.playTime;
      bool teamHasBall = team!.players.where((player) => player.hasBall).isNotEmpty;
      lastAction = null;

      if (teamHasBall) {
        _attack();
      } else {
        _defend();
      }

      if (lastAction != null) _streamController?.add(PlayerActEvent(player: this, action: lastAction!));
    });
  }

  gameEnd() async {
    gameRecord.add(_currentGameRecord);
    _timer?.cancel();
    await _streamController?.close();
    _streamController = null;

    _currentGameRecord = PlayerGameRecord.init();
    _currentStamina = 100;
    resetPosXY();
    _growAfterPlay();
  }

  bool _checkBoundary({
    required PosXY targetPosXY,
    required PosXY otherPosXY,
    double? sideBoundary,
    double? frontBoundary,
    double? backBoundary,
    double? distance,
  }) {
    bool isInSideBoundary = sideBoundary == null ? true : (targetPosXY.x - otherPosXY.x).abs() <= sideBoundary;
    bool isInFrontBoundary = frontBoundary == null ? true : otherPosXY.y - targetPosXY.y <= frontBoundary;
    bool isInBackBoundary = backBoundary == null ? true : targetPosXY.y - otherPosXY.y <= backBoundary;
    bool isInDistance = distance == null ? true : targetPosXY.distance(otherPosXY) <= distance;
    return isInSideBoundary && isInDistance && isInFrontBoundary && isInBackBoundary;
  }

  ///특정 위치의 압박도를통해 얼마만큼의 능력치를 낼 수 잇는지 리턴해주는 메소드 0.5 ~ 1
  double _getEvadePressurePoint({
    required PosXY targetPosXY,
    required List<Player> opponents,
    required int evadePressStat,
  }) {
    return opponents.fold(1, (prev, opponent) {
      bool isInHardBoundary = _checkBoundary(
        targetPosXY: targetPosXY,
        otherPosXY: opponent.reversePosXy,
        sideBoundary: 5,
        frontBoundary: 10,
        backBoundary: 0,
        distance: 7,
      );

      bool isInSoftBoundary = _checkBoundary(
        targetPosXY: targetPosXY,
        otherPosXY: opponent.reversePosXy,
        sideBoundary: 25,
        frontBoundary: 35,
        backBoundary: 5,
        distance: 30,
      );

      bool isInSoftVerticalBoundary = _checkBoundary(
        targetPosXY: targetPosXY,
        otherPosXY: opponent.reversePosXy,
        sideBoundary: 20,
        frontBoundary: 70,
        backBoundary: 5,
        distance: 70,
      );

      if (isInHardBoundary) {
        return 0.25 + 0.75 * prev * evadePressStat / (evadePressStat + opponent.pressureStat);
      } else if (isInSoftBoundary) {
        double softPressure = (opponent.pressureStat / 4);
        return 0.25 + 0.75 * prev * evadePressStat / (evadePressStat + softPressure);
      } else if (isInSoftVerticalBoundary) {
        double softVerticalPressure = (opponent.pressureStat / 6);
        return 0.25 + 0.75 * prev * evadePressStat / (evadePressStat + softVerticalPressure);
      } else {
        return prev;
      }
    });
  }

  double _getPassStat(PosXY targetPos) {
    double baselineStat = 0;
    if (targetPos.y > 180) {
      if (targetPos.distance(posXY) < 100) {
        baselineStat = sqrt(keyPassStat * shortPassStat);
      } else {
        baselineStat = sqrt(keyPassStat * longPassStat);
      }
    } else {
      if (targetPos.distance(posXY) < 100) {
        baselineStat = shortPassStat.toDouble();
      } else {
        baselineStat = longPassStat.toDouble();
      }
    }

    return baselineStat;
  }

  _getPosXYAttractive({
    required PosXY targetPosXY,
    required List<Player> opponentPlayers,
    required int evadePressStat,
  }) {
    double attractive = 0;

    ///본인보다 15 이상 앞에있으면 매력도 상승
    if (targetPosXY.y > posXY.y + 15) attractive += 30;

    /// 상대 골대에 가까울 수록 매력도 상승 0 ~ 150
    attractive += targetPosXY.y * 0.15;
    if (targetPosXY.y > 100) attractive += targetPosXY.y * 0.05;
    if (targetPosXY.y > 150) attractive += targetPosXY.y * 0.1;

    ///선수가 경기장 앞쪽 중앙에있을 수록 매력도 상승 0 ~ 25
    if (targetPosXY.y > 165 && posXY.x > 40 && posXY.x < 60) {
      attractive += targetPosXY.y / 8;
    }

    ///선수와의 거리가 가까울수록 매력도 상승 0 ~ 60점
    attractive += switch (targetPosXY.distance(posXY)) {
          < 20 => 40,
          < 35 => 30,
          < 55 => 20,
          < 80 => 10,
          _ => 0,
        } *
        switch (tactics.shortPassLevel) {
          PlayLevel.max => 2,
          PlayLevel.hight => 1.5,
          PlayLevel.middle => 1,
          PlayLevel.low => 0.5,
          PlayLevel.min => 0,
        } *
        switch (team?.tactics.shortPassLevel) {
          PlayLevel.max => 2,
          PlayLevel.hight => 1.5,
          PlayLevel.middle => 1,
          PlayLevel.low => 0.5,
          PlayLevel.min => 0,
          _ => 1,
        };

    attractive *= _getEvadePressurePoint(evadePressStat: evadePressStat, opponents: opponentPlayers, targetPosXY: targetPosXY);

    return attractive;
  }

  Player _getMostAttractivePlayerToPass({
    required List<Player> players,
    required List<Player> opponentPlayers,
  }) {
    ///활용 가능한 선수들의 매력도를 판단
    for (var player in players) {
      ///매력도를 0으로 초기화
      player.attractive = 0;

      player.attractive = _getPosXYAttractive(
        targetPosXY: player.posXY,
        opponentPlayers: opponentPlayers,
        evadePressStat: player.evadePressStat,
      );

      if (player.role == PlayerRole.goalKeeper) {
        player.attractive -= 300;
      }
    }

    players.sort((a, b) {
      if (a.attractive > b.attractive) {
        return b.posXY.y - a.posXY.y > 0 ? 1 : -1;
      } else {
        return b.attractive - a.attractive > 0 ? 1 : -1;
      }
    });

    return players.first;
  }

  _attack() {
    ///현재 내가 공을 잡은 상태인 경우
    if (hasBall) {
      _attackOnTheBall();

      ///공을 가지고 있지 않을 때
    } else {
      _attackOffTheBall();
    }
  }

  bool get hasBall => _hasBall;

  set hasBall(bool newVal) {
    _hasBall = newVal;

    if (newVal) _pause();
  }

  _attackOnTheBall() {
    ///골킥 초기화
    _currentFixture.isGoalKick = false;

    ///우리팀 선수들
    List<Player> ourTeamPlayers = [...team!.players.where((p) => p.id != id)];

    ///상대팀 선수들
    List<Player> opponentPlayers = _opponentTeamCurrentFixture.club.players;

    ///탈압박 점수
    double evadePressurePoint = _getEvadePressurePoint(evadePressStat: evadePressStat, opponents: opponentPlayers, targetPosXY: posXY);

    ///상대선수 골키퍼
    Player goalKeeper = opponentPlayers.firstWhere(
      (player) => player.role == PlayerRole.goalKeeper,
    );

    ///내가 활용 가능한 우리팀 선수들: canVisibleDistance 이내
    List<Player> availablePlayerToPass = ourTeamPlayers.where((teamPlayer) {
      bool canPass = true;
      for (var opponent in opponentPlayers) {
        ///너무 가까운 상대를 제외
        if (opponent.reversePosXy.distance(posXY) > 5) {
          ///패스 길 사이에 적이 있는지 여부
          bool isOpponentBetween = opponent.reversePosXy.x >= min(posXY.x, teamPlayer.posXY.x) &&
              opponent.reversePosXy.x <= max(posXY.x, teamPlayer.posXY.x) &&
              opponent.reversePosXy.y >= min(posXY.y, teamPlayer.posXY.y) &&
              opponent.reversePosXy.y <= max(posXY.y, teamPlayer.posXY.y);

          ///패스 길과 해당 선수와의 거리
          double distanceToPathRoute = min(1, M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: teamPlayer.posXY, point: opponent.reversePosXy));

          bool canNotSee = teamPlayer.posXY.distance(posXY) > (visionStat * evadePressurePoint) || (isOpponentBetween && distanceToPathRoute < 10);

          if (canNotSee) {
            canPass = false;
            break;
          }
        }
      }

      return canPass;
    }).toList();

    ///골포스트 까지의 거리
    double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

    ///포지션이 골키퍼인 경우
    if (position == Position.gk) {
      if (availablePlayerToPass.isEmpty) {
        _clearance();
      } else {
        Player target = _getMostAttractivePlayerToPass(players: availablePlayerToPass, opponentPlayers: opponentPlayers);
        _pass(target, opponentPlayers, evadePressurePoint);
      }

      return;
    }

    ///TODO:header
    if (posXY.x > 40 && posXY.x < 60 && posXY.y > 185) {
      _shoot(goalKeeper: goalKeeper, evadePressurePoint: evadePressurePoint);
      return;
    }

    /// 드리블 했을 때 이득인지 여부
    double beforeDribbleAttractive = _getPosXYAttractive(evadePressStat: evadePressStat, opponentPlayers: opponentPlayers, targetPosXY: posXY);
    double afterDribbleAttractive = _getPosXYAttractive(evadePressStat: evadePressStat, opponentPlayers: opponentPlayers, targetPosXY: PosXY(posXY.x, posXY.y + maxDistance));

    bool batterDribble = afterDribbleAttractive >= beforeDribbleAttractive;

    ///주변에 활용 가능한 선수가 안보일 때
    if (availablePlayerToPass.isEmpty) {
      if (posXY.y < 35) {
        _clearance();
      } else {
        // int nearOpponentNum = opponentPlayers.where((opponent) => opponent.reversePosXy.distance(posXY) < 10).length;

        if (batterDribble) {
          _dribble();
        } else {
          _moveToBetterPos(opponentPlayers);
        }
      }
      return;
    }

    ///슛을 했을 때 일정경로 이내에 있는 선수의 수 - 슛스텟이 높아질수록 정교해짐
    int opponentsNumNearShootRout = opponentPlayers.where((opponent) {
      return opponent.reversePosXy.x >= min(posXY.x, goalKeeper.reversePosXy.x) &&
          opponent.reversePosXy.x <= max(posXY.x, goalKeeper.reversePosXy.x) &&
          opponent.reversePosXy.y >= min(posXY.y, goalKeeper.reversePosXy.y) &&
          opponent.reversePosXy.y <= max(posXY.y, goalKeeper.reversePosXy.y) &&
          M().getDistanceFromPointToLine(
                linePoint1: posXY,
                linePoint2: goalKeeper.reversePosXy,
                point: opponent.reversePosXy,
              ) <
              (32 - shootingStat * 0.3);
    }).length;

    double shootBonus = switch (tactics.shootLevel) {
          PlayLevel.min => 0.8,
          PlayLevel.low => 0.9,
          PlayLevel.middle => 1,
          PlayLevel.hight => 1.1,
          PlayLevel.max => 1.2,
        } *
        switch (team?.tactics.shootLevel) {
          PlayLevel.min => 0.8,
          PlayLevel.low => 0.9,
          PlayLevel.middle => 1,
          PlayLevel.hight => 1.1,
          PlayLevel.max => 1.2,
          _ => 1,
        };

    /// 경기장 중앙에 있는 경우
    bool canShortShoot = posXY.x > 30 && posXY.x < 70 && opponentsNumNearShootRout < R().getDouble(min: 0.5, max: 10.5 * shootBonus);

    bool canMidrangeShortShoot = posXY.x > 25 && posXY.x < 75;
    bool canMidrangeShoot = canMidrangeShortShoot && pow(distanceToGoalPost, 2.05) / midRangeShootStat < R().getDouble(min: 35, max: 120 * shootBonus);

    ///슈팅 가능한 경우
    if (distanceToGoalPost < 30 ? canShortShoot : canMidrangeShoot) {
      _shoot(
        evadePressurePoint: evadePressurePoint,
        goalKeeper: goalKeeper,
      );
      return;
    }

    ///슈팅이 불가능한 경우
    else {
      bool nearByGoalPost = (posXY.y > 165 && !(posXY.x > 35 && posXY.x < 65));

      double dribbleBonus = switch (dribbleStat) {
            > 100 => 1.2,
            > 80 => 1,
            > 70 => 0.9,
            > 60 => 0.8,
            > 50 => 0.7,
            > 40 => 0.5,
            > 30 => 0.3,
            _ => 1,
          } *
          switch (tactics.dribbleLevel) {
            PlayLevel.min => 0.8,
            PlayLevel.low => 0.9,
            PlayLevel.middle => 1,
            PlayLevel.hight => 1.1,
            PlayLevel.max => 1.2,
          } *
          switch (team?.tactics.dribbleLevel) {
            PlayLevel.min => 0.8,
            PlayLevel.low => 0.9,
            PlayLevel.middle => 1,
            PlayLevel.hight => 1.1,
            PlayLevel.max => 1.2,
            _ => 1,
          };
      Player passTarget = _getMostAttractivePlayerToPass(players: availablePlayerToPass, opponentPlayers: opponentPlayers);

      double passTargetAttractive = _getPosXYAttractive(targetPosXY: passTarget.posXY, opponentPlayers: opponentPlayers, evadePressStat: evadePressStat);
      double afterDribbleAttractive = _getPosXYAttractive(evadePressStat: evadePressStat, opponentPlayers: opponentPlayers, targetPosXY: PosXY(posXY.x, posXY.y + maxDistance));

      double passTreatment = _passTreatment(passTarget, opponentPlayers);

      bool batterDribble = afterDribbleAttractive * dribbleBonus >= passTargetAttractive - passTreatment;

      int nearOpponentNum = opponentPlayers.where((opponent) => opponent.reversePosXy.distance(posXY) < 10).length;

      if (nearByGoalPost || batterDribble && nearOpponentNum == 0) {
        _dribble();
      } else {
        _pass(passTarget, opponentPlayers, evadePressurePoint);
      }
      return;
    }
  }

  double _passTreatment(Player target, List<Player> opponents) {
    double treatment = posXY.distance(target.posXY) / 10;

    for (var opponent in opponents) {
      bool isNotClose = opponent.reversePosXy.distance(posXY) > 10;

      ///패스 길 사이에 적이 있는지 여부
      bool isOpponentBetween = opponent.reversePosXy.x >= min(posXY.x, target.posXY.x) &&
          opponent.reversePosXy.x <= max(posXY.x, target.posXY.x) &&
          opponent.reversePosXy.y >= min(posXY.y, target.posXY.y) &&
          opponent.reversePosXy.y <= max(posXY.y, target.posXY.y);

      ///패스 길과 해당 선수와의 거리
      double distanceToPathRoute = min(1, M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: target.posXY, point: opponent.reversePosXy));

      if (isNotClose && isOpponentBetween && distanceToPathRoute < 10) treatment += 5;
    }

    return treatment;
  }

  _attackOffTheBall() {
    if (role == PlayerRole.goalKeeper) {
      _move(targetPosXY: PosXY.random(startingPoxXY.x, startingPoxXY.y, 5));
      return;
    }

    ///우리팀 선수들
    List<Player> ourTeamPlayers = [...team!.players.where((p) => p.id != id)];

    ///상대팀 선수들
    List<Player> opponentPlayers = _opponentTeamCurrentFixture.club.players;

    ///탈압박 점수
    double evadePressurePoint = _getEvadePressurePoint(evadePressStat: evadePressStat, opponents: opponentPlayers, targetPosXY: posXY);

    ///나와 포지션인 같은데 볼과 가까이있는 플레이어 리스트
    List<Player> nearBallPlayers = ourTeamPlayers
        .where((player) =>
            _checkBoundary(
              targetPosXY: _ballPosXY,
              otherPosXY: player.posXY,
              frontBoundary: 30,
              backBoundary: -10,
              distance: 35,
            ) &&
            player.position == position)
        .toList();

    ///나와 포지션이 같은데 나보다 공과 가까이있는 플레이어
    int nearThanMePlayer = 0;

    for (var player in ourTeamPlayers) {
      if (!player.hasBall && (_ballPosXY.distance(player.startingPoxXY) < _ballPosXY.distance(startingPoxXY)) && player.role == role) nearThanMePlayer++;
    }

    bool isRearGuardPlayer = nearThanMePlayer <
        switch (role) {
          PlayerRole.defender => 1,
          PlayerRole.midfielder => 1,
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

    bool isBallBehind = posXY.y > _ballPosXY.y;

    bool ballDistanceCheck = _ballPosXY.distance(posXY) > 20;

    if (noBallAroundBall && isRearGuardPlayer && isBallBehind && ballDistanceCheck) {
      _moveToBallForPass(_ballPosXY);
    } else if (evadePressurePoint == 1 && posXY.y > 130) {
      _moveToBetterPos(opponentPlayers);
    } else {
      List<Player> sortedPlayers = [...opponentPlayers];
      sortedPlayers.sort((a, b) => a.posXY.y - b.posXY.y > 0 ? 1 : -1);
      moveForward(sortedPlayers[1]);
    }
  }

  _defend() {
    if (_currentFixture.playerWithBall == null) return;
    bool isNotGoalKick = _currentFixture.playerWithBall?.role != PlayerRole.goalKeeper;

    PosXY ballPos = PosXY(100 - _ballPosXY.x, 200 - _ballPosXY.y);
    bool canTackle = ballPos.distance(posXY) < tackleDistance && isNotGoalKick;

    int closerPlayerAtBall = team!.players.where((player) => player.reversePosXy.distance(_ballPosXY) < reversePosXy.distance(_ballPosXY)).length;

    bool canPress = (tactics.pressDistance + team!.tactics.pressDistance > ballPos.distance(startingPoxXY)) &&
        isNotGoalKick &&
        !(ballPos.x == posXY.x && ballPos.y == posXY.y) &&
        closerPlayerAtBall < _ballPosXY.y / 50;

    if (canTackle) {
      _tackle(_currentFixture.playerWithBall!);
    } else if (canPress) {
      _pressToBall(_ballPosXY);
    } else {
      if (_ballPosXY.distance(reversePosXy) > 50 && ballPos.y > posXY.y) {
        _backToStartPos();
      } else {
        moveBack();
      }
    }
  }

  _backToStartPos() {
    _move(targetPosXY: PosXY.random(startingPoxXY.x, startingPoxXY.y, 5));
  }

  _moveToBetterPos(List<Player> opponents) {
    lastAction = PlayerAction.none;

    double attBonus = 1 *
        switch (tactics.attackLevel) {
          PlayLevel.max => 4,
          PlayLevel.hight => 2,
          PlayLevel.middle => 1,
          PlayLevel.low => 0.5,
          PlayLevel.min => 0.25,
        } *
        switch (team?.tactics.attackLevel) {
          PlayLevel.max => 4,
          PlayLevel.hight => 2,
          PlayLevel.middle => 1,
          PlayLevel.low => 0.5,
          PlayLevel.min => 0.25,
          _ => 1,
        };

    List<PosXY> poss = List.generate(5, (index) => PosXY.random(posXY.x, posXY.y + attBonus, 5));

    poss.sort((a, b) =>
        _getEvadePressurePoint(evadePressStat: evadePressStat, opponents: opponents, targetPosXY: a) - _getEvadePressurePoint(evadePressStat: evadePressStat, opponents: opponents, targetPosXY: b) > 0
            ? 1
            : -1);

    _move(targetPosXY: poss.first);
  }

  moveForward(Player rearGuardPlayer) {
    lastAction = PlayerAction.move;
    _move(targetPosXY: PosXY.random(posXY.x, (posXY.y + maxDistance).clamp(0, rearGuardPlayer.reversePosXy.y), 5));
  }

  moveBack() {
    lastAction = PlayerAction.move;

    _move(targetPosXY: PosXY.random(posXY.x, posXY.y - maxDistance, 2));
  }

  _dribble() {
    int tackledPlayerNum = 0;
    for (var player in _opponentTeamCurrentFixture.club.players) {
      if (player.reversePosXy.distance(posXY) < player.tackleDistance && player.reversePosXy.y > posXY.y && hasBall) {
        tackledPlayerNum++;
        player._tackle(this);
      }
    }

    if (hasBall) {
      if (tackledPlayerNum > 0) {
        lastAction = PlayerAction.dribble;
        dribbleSuccess();
        _myTeamCurrentFixture.dribble++;
      }

      PosXY newPos = PosXY.random(posXY.x, posXY.y + maxDistance, 2);

      if (posXY.y > 170) newPos = PosXY(50, 200);

      _move(targetPosXY: newPos);
    }
  }

  _turn(PosXY targetPosXY) {
    double radian = atan2(targetPosXY.y - posXY.y, targetPosXY.x - posXY.x);

    rotateDegree = radian;
    _streamController?.add(PlayerActEvent(player: this, action: PlayerAction.none));
  }

  _clearance() {
    Player receivedPlayer = _findClosetPlayer(
        PosXY(
          R().getDouble(min: 0, max: 100),
          R().getDouble(min: 150, max: 200),
        ),
        [...team!.players],
        [..._opponentTeamCurrentFixture.club.players]);
    hasBall = false;
    receivedPlayer.hasBall = true;
  }

  Player _findClosetPlayer(PosXY targetPos, List<Player> team, List<Player> opponents) {
    team.sort((a, b) => a.posXY.distance(targetPos) - b.posXY.distance(targetPos) > 0 ? 1 : -1);
    opponents.sort((a, b) => a.reversePosXy.distance(targetPos) - b.reversePosXy.distance(targetPos) > 0 ? 1 : -1);

    return team.first.posXY.distance(targetPos) < opponents.first.reversePosXy.distance(targetPos) ? team.first : opponents.first;
  }

  _pass(Player target, List<Player> opponents, double evadePressurePoint) async {
    passTry();
    _turn(target.posXY);
    lastAction = PlayerAction.pass;

    double baselineStat = _getPassStat(target.posXY);

    for (var opponent in opponents) {
      ///패스 길 사이에 적이 있는지 여부
      bool isOpponentBetween = opponent.reversePosXy.x >= min(posXY.x, target.posXY.x) &&
          opponent.reversePosXy.x <= max(posXY.x, target.posXY.x) &&
          opponent.reversePosXy.y >= min(posXY.y, target.posXY.y) &&
          opponent.reversePosXy.y <= max(posXY.y, target.posXY.y);

      ///패스 길과 해당 선수와의 거리
      double distanceToPathRoute = min(1, M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: target.posXY, point: opponent.reversePosXy));

      double interceptPercent = (opponent.interceptStat) / (100 + baselineStat * distanceToPathRoute);

      if (isOpponentBetween && distanceToPathRoute < 10 && interceptPercent > R().getDouble(max: 2.6)) {
        opponent._streamController?.add(PlayerActEvent(player: opponent, action: PlayerAction.intercept));
        opponent.intercept();
        hasBall = false;
        opponent.hasBall = true;
        break;
      }
    }

    if (hasBall) {
      hasBall = false;

      ///현재 선수 위치와 패스받으려는 선수 위치의 차이
      double passDistance = target.posXY.distance(posXY);

      ///최종 볼 정확도(낮을수록 정확) 5 ~ 30
      double ballLandingAccuracy = min(max(5, passDistance - baselineStat * evadePressurePoint), 30);

      PosXY ballLandingPos = PosXY.random(target.posXY.x, target.posXY.y, ballLandingAccuracy);

      _currentFixture.ball.isMoving = true;
      _currentFixture.ball.moveDistance = passDistance;

      Player receivedPlayer = _findClosetPlayer(ballLandingPos, [target], [...opponents]);
      if (receivedPlayer.id == target.id) {
        passSuccess();
        target.passedPlayer = this;
        _myTeamCurrentFixture.pass += 1;
      }
      receivedPlayer.hasBall = true;
    }
  }

  _shoot({
    required Player goalKeeper,
    required double evadePressurePoint,
  }) {
    lastAction = PlayerAction.shoot;
    _myTeamCurrentFixture.shoot += 1;
    shooting();

    double distanceToGoalPost = goalKeeper.posXY.distance(reversePosXy);

    int stat = distanceToGoalPost < 30 ? shootingStat : midRangeShootStat;

    double finalShootStat = stat * evadePressurePoint * (R().getDouble(max: 1) > 0.85 ? 3.5 : 1);

    bool isShootOnTarget = finalShootStat > R().getDouble(min: 120.0 - max(stat, 120), max: 120);

    if (isShootOnTarget) {
      shootOnTarget();
    }

    double finalKeepingStat = goalKeeper.keepingStat * (R().getDouble(max: 1) > 0.9 ? 3.5 : 1) + distanceToGoalPost * 0.75;

    bool isGoal = finalShootStat / finalKeepingStat > R().getDouble(min: 0.12, max: 0.72) && isShootOnTarget;

    if (isGoal) {
      goal();
      _streamController?.add(PlayerActEvent(player: this, action: PlayerAction.goal));
      if (passedPlayer != null) passedPlayer?._streamController?.add(PlayerActEvent(player: passedPlayer!, action: PlayerAction.assist));

      _currentFixture.scored(
        scoredClub: _myTeamCurrentFixture,
        concedeClub: _opponentTeamCurrentFixture,
        scoredPlayer: this,
        assistPlayer: passedPlayer,
      );
    } else {
      _currentFixture.isGoalKick = true;
      hasBall = false;
      goalKeeper.hasBall = true;
    }
  }

  _tackle(Player targetPlayer) {
    double tackleSuccessPercent = tackleStat / (tackleStat + targetPlayer.evadePressStat);

    if (tackleSuccessPercent > R().getDouble(min: 0.35, max: 1.05)) {
      lastAction = PlayerAction.tackle;
      defSuccess();
      targetPlayer.hasBall = false;
      targetPlayer._pause();
      hasBall = true;
      _myTeamCurrentFixture.tackle += 1;
    } else {
      _pause();
    }
  }

  _moveToBallForPass(PosXY ballPosXY) {
    double ballPosX = ballPosXY.x;
    double ballPosY = ballPosXY.y + 20;
    lastAction = PlayerAction.move;

    _move(targetPosXY: PosXY(ballPosX, ballPosY));
  }

  _pressToBall(PosXY ballPosXY) {
    double ballPosX = 100 - ballPosXY.x;
    double ballPosY = 200 - ballPosXY.y;
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
    double distanceCanForward = min(distanceToTarget, maxDistance);

    /// sine,cosine값 구하기
    double sine = deltaY / distanceToTarget;
    double cosine = deltaX / distanceToTarget;

    /// x,y 축으로의 실제 이동거리
    double travelX = distanceCanForward * cosine;
    double travelY = distanceCanForward * sine;

    PosXY wantPos = PosXY(posXY.x + travelX, posXY.y + travelY);

    if (!hasBall && startingPoxXY.distance(wantPos) > startingPoxXY.distance(posXY)) {
      ///새로 이동하는곳이 기존 위치보다 스타팅 포인트에서 더 멀리 떨어진 곳이면 저항치 증가
      double resistanceXByStarting = wantPos.distance(startingPoxXY) > posXY.distance(startingPoxXY) ? (200 - wantPos.distance(startingPoxXY)) / 150 : 1;

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
      _currentStamina -= moveDistance / max(1, stat.stamina);
    } else if (_currentStamina > 1) {
      _currentStamina *= 0.95;
    }

    if (moveDistance > 5) {
      _turn(wantPos);
    }

    posXY = wantPos;
  }

  goal() {
    _currentGameRecord.goal++;
  }

  assist() {
    _currentGameRecord.assist++;
  }

  passTry() {
    _currentGameRecord.passTry++;
  }

  passSuccess() {
    _currentGameRecord.passSuccess++;
  }

  intercept() {
    _currentGameRecord.intercept++;
  }

  shooting() {
    _currentGameRecord.shooting++;
  }

  shootOnTarget() {
    _currentGameRecord.shootOnTarget++;
  }

  defSuccess() {
    _currentGameRecord.defSuccess++;
  }

  saveSuccess() {
    _currentGameRecord.saveSuccess++;
  }

  dribbleSuccess() {
    _currentGameRecord.dribbleSuccess++;
  }
}
