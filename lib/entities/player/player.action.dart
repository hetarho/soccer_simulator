part of 'player.dart';

extension PlayerMove on Player {
  ///상대방의 위치가 특정 포지션을 압박할 수 있는지를 리턴해주는 함수
  bool _isCanPressure(PosXY targetPos, PosXY opponentPos) {
    bool isClosePosX = opponentPos.x < targetPos.x + 15 && opponentPos.x > targetPos.x - 15;
    bool isClosePosY = opponentPos.y > targetPos.y && opponentPos.y - 5 < targetPos.y + 20;
    return isClosePosX && isClosePosY;
  }

  Player getMostAttractivePlayer(List<Player> players, List<Player> opponentPlayers) {
    ///활용 가능한 선수들의 매력도를 판단
    List<Player> judgedTeamPlayer = players.map((player) {
      ///매력도를 0으로 초기화
      player.attractive = 0;

      ///선수가 앞쪽에 있을 수록 매력도 상승
      player.attractive += player.posXY.y;

      ///선수의 능력치가 높을 수록 매력도 상승
      player.attractive += player.overall;

      ///상대편 선수들과 해당 선수의 거리를 비교
      for (var opponent in opponentPlayers) {
        ///해당 선수에게 패스시 패스길과 적의 거리
        double distanceToPathRoute =
            M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: player.posXY, point: opponent.reversePosXy);

        ///해당 선수에게 패스시 패스길과 특정 거리 이내 매력도 하락
        double unit = 12.0;
        if (distanceToPathRoute < unit) {
          player.attractive -= distanceToPathRoute * unit * 1.6;
        }

        if (_isCanPressure(player.posXY, opponent.reversePosXy)) {
          double distanceToOpponent = player.posXY.distance(opponent.reversePosXy);
          player.attractive -= distanceToOpponent * 1.4;
        }
      }

      return player;
    }).toList();

    judgedTeamPlayer.sort((a, b) => b.attractive - a.attractive > 0 ? 1 : -1);

    return judgedTeamPlayer.first;
  }

  attack({
    required ClubInFixture team,
    required ClubInFixture opponent,
    required Ball ball,
    required Fixture fixture,
  }) {
    ///현재 내가 공을 잡은 상태인 경우
    if (hasBall) {
      ///우리팀 선수들
      List<Player> ourTeamPlayers = [...team.club.players.where((p) => p.id != id)];

      ///상대팀 선수들
      List<Player> opponentPlayers = opponent.club.players;

      /// 판단력/5 만큼 행동 포인트 적립
      _actPoint += judgementStat / 10;

      ///나에게 압박을 주는 상대팀 선수들
      List<Player> pressureOpponentPlayers =
          opponentPlayers.where((opponent) => _isCanPressure(posXY, opponent.reversePosXy)).toList();

      ///공을 잡을 선수가 느끼는 압박감: 주위 선수들의 압박스텟 / 상대와의 거리 - 나의 탈압박 능력
      double pressureIntensity = pressureOpponentPlayers.fold(0.0, (prev, opponent) {
        return prev + opponent.pressureStat * 5 / posXY.distance(opponent.reversePosXy);
      });

      ///압박을 고려한 식별 가능한 거리
      double canVisibleDistance = visionStat - min(0, pressureIntensity - evadePressStat);

      ///내가 활용 가능한 우리팀 선수들: canVisibleDistance 이내
      List<Player> visibleOurTeamPlayers =
          ourTeamPlayers.where((teamPlayer) => teamPlayer.posXY.distance(posXY) < canVisibleDistance).toList();

      ///주변에 활용 가능한 선수가 안보일 때
      if (visibleOurTeamPlayers.isEmpty) {
        ///압박감이 0보다 낮을 때
        if (pressureIntensity < 0) {
          dribble(team);
        } else {
          moveBack();
        }
        return;
      }
      print('pressureIntensity - evadePressStat :${pressureIntensity - evadePressStat}');

      /// actPoint가 10 이하인경우 대기만 가능
      if (_actPoint < 10) {
        stay();
        return;
      } else if (_actPoint < 25) {
        ///탈압박이 불가능 할 경우
        if (pressureIntensity - evadePressStat > 0) {
          List<Player> behindPlayers = ourTeamPlayers.where((player) => player.posXY.y < posXY.y + 5).toList();
          Player target = getMostAttractivePlayer(behindPlayers, opponentPlayers);
          List<Player> nearOpponentAtTarget =
              opponentPlayers.where((opponent) => opponent.posXY.distance(target.reversePosXy) < 15).toList();
          pass(target, team, nearOpponentAtTarget, fixture);

          ///탈압박이 가능한경우 일단 대기
        } else {
          stay();
        }
        return;
      }

      ///활용 가능한 선수들의 매력도를 판단
      List<Map<String, dynamic>> judgedTeamPlayer = visibleOurTeamPlayers.map((player) {
        double attractive = 0;

        ///선수가 앞쪽에 있을 수록 매력도 상승
        attractive += player.posXY.y;

        ///선수의 능력치가 높을 수록 매력도 상승
        attractive += player.overall;

        ///상대편 선수들과 해당 선수의 거리를 비교
        for (var opponent in opponentPlayers) {
          ///해당 선수에게 패스시 패스길과 적의 거리
          double distanceToPathRoute =
              M().getDistanceFromPointToLine(linePoint1: posXY, linePoint2: player.posXY, point: opponent.reversePosXy);

          ///해당 선수에게 패스시 패스길과 특정 거리 이내 매력도 하락
          double unit = 12.0;
          if (distanceToPathRoute < unit) {
            attractive -= distanceToPathRoute * unit * 1.6;
          }

          if (_isCanPressure(player.posXY, opponent.reversePosXy)) {
            double distanceToOpponent = player.posXY.distance(opponent.reversePosXy);
            attractive -= distanceToOpponent * 1.4;
          }
        }

        // print('attractive:$attractive');

        return {
          "attractive": attractive,
          "player": player,
        };
      }).toList();

      judgedTeamPlayer.sort((a, b) => b['attractive'] - a['attractive'] > 0 ? 1 : -1);

      int shootPercent = max(0, ((2500 - pow(PosXY(50, 200).distance(posXY), 2))).round());
      int passPercent = 250;

      int dribbleBonus = (11 -
          opponentPlayers
              .where((opponent) =>
                  ((100 - opponent.posXY.x + 15) > posXY.x && (100 - opponent.posXY.x - 15) < posXY.x) ||
                  (200 - opponent.posXY.y - posXY.y) > 50)
              .length);
      int dribblePercent = position == Position.goalKeeper ? 0 : (50 + dribbleBonus * 100);
      int stayPercent = position == Position.goalKeeper ? 0 : 250;
      int ranNum = R().getInt(min: 0, max: shootPercent + passPercent + dribblePercent + stayPercent);

      bool canShoot = true;

      if (canShoot && (ranNum < shootPercent || (posXY.y > 180))) {
        shoot(
            fixture: fixture,
            team: team,
            opponent: opponent,
            goalKeeper: opponentPlayers.firstWhere((player) => player.position == Position.goalKeeper));
      } else if (ranNum < shootPercent + passPercent) {
        Player target = judgedTeamPlayer.first["player"];

        List<Player> nearOpponentAtTarget =
            opponentPlayers.where((opponent) => opponent.posXY.distance(target.reversePosXy) < 15).toList();

        pass(target, team, nearOpponentAtTarget, fixture);
      } else if (ranNum < shootPercent + passPercent + dribblePercent) {
        dribble(team);
      } else {
        stay();
      }
    } else {
      int ranNum = R().getInt(min: 0, max: 100);
      switch (ranNum) {
        case < 40:
          stay();
          break;
        case < 100:
          moveFront();
          break;
        case < 7:
          break;
        default:
          break;
      }
    }
  }

  defend({
    required ClubInFixture team,
    required ClubInFixture opponent,
    required Ball ball,
    required Fixture fixture,
  }) {
    PosXY ballPos = PosXY(100 - ball.posXY.x, 200 - ball.posXY.y);
    bool canTackle = ballPos.distance(posXY) < 8 && (fixture.playerWithBall?.position != Position.goalKeeper);

    bool canPress = ((tactics?.pressDistance ?? 0) + team.club.tactics.pressDistance > ballPos.distance(posXY));

    if (canTackle) {
      int tacklePercent = 50;
      int moveBackPercent = 100;
      int ranNum = R().getInt(min: 0, max: tacklePercent + moveBackPercent);

      if (ranNum < tacklePercent && fixture.playerWithBall != null) {
        tackle(fixture.playerWithBall!, team);
      } else if (ranNum < tacklePercent + moveBackPercent) {
        stay();
      }
    } else {
      if (canPress) {
        press(ball.posXY);
      } else {
        moveBack();
      }
    }
  }

  stay() {
    lastAction = PlayerAction.none;
    _move(targetPosition: PosXY.random(posXY.x, posXY.y, 3));
  }

  moveFront() {
    lastAction = PlayerAction.none;
    double frontDistance = switch (position) {
      Position.forward => 16,
      Position.midfielder => 12,
      Position.defender => isWinger ? 15 : 8,
      _ => 0,
    };
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + frontDistance, 3), maximumDistance: maxDistance);
  }

  moveBack() {
    lastAction = PlayerAction.none;
    double backDistance = -1 * min(10, (posXY.y - startingPoxXY.y * 0.5) * 0.2);

    _move(targetPosition: PosXY.random(posXY.x, posXY.y + backDistance, 2), maximumDistance: maxDistance);
  }

  dribble(ClubInFixture team) {
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + 15, 10), maximumDistance: maxDistance);
    lastAction = PlayerAction.dribble;
    dribbleSuccess++;
    team.dribble++;
  }

  pass(Player target, ClubInFixture team, List<Player> nearOpponentAtTarget, Fixture fixture) {
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

    nearOpponentAtTarget.sort((a, b) => a.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) -
                b.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) >
            0
        ? 1
        : -1);

    double targetDistance = target.posXY.distance(ballLandingPos);
    hasBall = false;
    if (nearOpponentAtTarget.isEmpty ||
        targetDistance <
            nearOpponentAtTarget.first.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y))) {
      passSuccess++;
      target.passedPlayer = this;
      target.hasBall = true;
      team.pass += 1;
    } else {
      nearOpponentAtTarget.first.hasBall = true;
    }
  }

  shoot({
    required Player goalKeeper,
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opponent,
  }) {
    lastAction = PlayerAction.shoot;
    hasBall = false;
    goalKeeper.hasBall = true;
    team.shoot += 1;
    shooting++;

    double distanceBonus = goalKeeper.posXY.distance(reversePosXy) / 5;

    if ((shootingStat / (goalKeeper.keepingStat * distanceBonus)) > R().getDouble(max: 1)) {
      goal++;
      fixture.scored(
        scoredClub: team,
        concedeClub: opponent,
        scoredPlayer: this,
        assistPlayer: passedPlayer,
      );
    }
  }

  tackle(Player targetPlayer, ClubInFixture team) {
    double distanceBonus = targetPlayer.posXY.distance(reversePosXy) / 7;

    if ((overall / (targetPlayer.overall * distanceBonus + overall)) > R().getDouble(max: 1)) {
      lastAction = PlayerAction.tackle;
      defSuccess++;
      targetPlayer.hasBall = false;
      hasBall = true;
      team.tackle += 1;
    } else {}
  }

  press(PosXY ballPosition) {
    double ballPositionX = 100 - ballPosition.x;
    double ballPositionY = 200 - ballPosition.y;
    lastAction = PlayerAction.press;

    _move(targetPosition: PosXY(ballPositionX, ballPositionY), maximumDistance: maxDistance);
  }

  _move({
    required PosXY targetPosition,
    double? maximumDistance,
  }) {
    /// x,y 좌표의 차이를 각각 구하기
    double deltaX = (targetPosition.x - posXY.x);
    double deltaY = (targetPosition.y - posXY.y);

    /// 해당 타깃과의 거리 구하기
    double distanceToTarget = PosXY(targetPosition.x, targetPosition.y).distance(posXY);

    /// 이동할 수 있는 최대 거리 구하기
    double distanceCanForward = min(distanceToTarget, maximumDistance ?? distanceToTarget);

    /// sine,cosine값 구하기
    double sine = deltaY / distanceToTarget;
    double cosine = deltaX / distanceToTarget;

    /// x,y 축으로의 실제 이동거리
    double travelX = distanceCanForward * cosine;
    double travelY = distanceCanForward * sine;

    ///최종 이동할 좌표
    PosXY newPos = PosXY((posXY.x + travelX).clamp(_posXMinBoundary, _posXMaxBoundary),
        (posXY.y + travelY).clamp(_posYMinBoundary, _posYMaxBoundary));

    ///실제 이동 거리
    double moveDistance = newPos.distance(posXY);

    ///TODO: 체력 감소 로직 추후 구체화
    if (_currentStamina > 30) {
      _currentStamina -= moveDistance / stat.stamina;
    } else {
      _currentStamina *= 0.95;
    }

    posXY = newPos;
  }
}
