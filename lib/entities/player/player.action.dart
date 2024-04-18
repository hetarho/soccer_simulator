part of 'player.dart';

extension PlayerMove on Player {
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

    ///나에게 영향을주는 상대팀 선수들: 10 거리 이내
    List<Player> nearOpponentPlayers = opponentPlayers.where((opponent) => opponent.posXY.distance(reversePosXy) < 10).toList();

    ///현재 내가 공을 잡은 상태인 경우
    if (hasBall) {
      ///공을 잡을 선수가 느끼는 압박감: 주위 선수들의 압박스텟 / 상대와의 거리 - 나의 탈압박 능력
      double pressureIntensity = min(
          0,
          nearOpponentPlayers.fold(0.0, (prev, opponent) {
                return prev + opponent.pressureStat * 2 / opponent.posXY.distance(reversePosXy);
              }) -
              evadePressStat.toDouble());

      ///내가 활용 가능한 우리팀 선수들: visionStat - pressureIntensity 거리 이내
      List<Player> visibleOurTeamPlayers = ourTeamPlayers.where((teamPlayer) => teamPlayer.posXY.distance(posXY) < (visionStat - pressureIntensity)).toList();

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

      ///활용 가능한 선수들의 매력도를 판단

      List<Map<String, dynamic>> judgedTeamPlayer = visibleOurTeamPlayers.map((player) {
        double attractive = 0;

        ///선수가 앞쪽에 있을 수록 매력도 상승
        attractive += player.posXY.y / 2;

        ///선수의 능력치가 높을 수록 매력도 상승
        attractive += player.overall;

        ///해당 선수에게 패스시 패스길과의 거리가 10 이내인 적의 수 *10 매력도 하락
        attractive -= opponentPlayers.where((opponent) {
              double distanceToPathRoute = sqrt(pow(reversePosXy.distance(opponent.posXY), 2) - pow(posXY.distance(player.posXY) / 2, 2));
              return distanceToPathRoute < 10;
            }).length *
            10;

        return {
          "attractive": attractive,
          "player": player,
        };
      }).toList();

      judgedTeamPlayer.sort((a, b) => b['attractive'] - a['attractive'] > 0 ? 1 : -1);

      int shootPercent = max(0, ((2500 - pow(PosXY(50, 200).distance(posXY), 2))).round());
      int passPercent = 250;

      int dribbleBonus = (11 - opponentPlayers.where((opponent) => ((100 - opponent.posXY.x + 15) > posXY.x && (100 - opponent.posXY.x - 15) < posXY.x) || (200 - opponent.posXY.y - posXY.y) > 50).length);
      int dribblePercent = position == Position.goalKeeper ? 0 : (50 + dribbleBonus * 100);
      int stayPercent = position == Position.goalKeeper ? 0 : 250;
      int ranNum = R().getInt(min: 0, max: shootPercent + passPercent + dribblePercent + stayPercent);

      bool canShoot = true;

      for (var opponent in nearOpponentPlayers) {
        double distanceBonus = 10 -
            opponent.posXY.distance(PosXY(
              100 - posXY.x,
              200 - posXY.y,
            ));

        if ((overall / (opponent.overall * distanceBonus + overall)) < R().getDouble(max: 1)) {
          canShoot = false;
        }
      }

      if (canShoot && (ranNum < shootPercent || (posXY.y > 180))) {
        shoot(fixture: fixture, team: team, opponent: opponent, goalKeeper: opponentPlayers.firstWhere((player) => player.position == Position.goalKeeper));
      } else if (ranNum < shootPercent + passPercent) {
        Player target = judgedTeamPlayer.first["player"];

        List<Player> nearOpponentAtTarget = opponentPlayers
            .where((opponent) =>
                opponent.posXY.distance(PosXY(
                  100 - target.posXY.x,
                  200 - target.posXY.y,
                )) <
                15)
            .toList();

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
    bool canTackle = ballPos.distance(posXY) < 12;

    double personalPressBonus = switch (position) {
      Position.forward when ballPos.y > posXY.y => 100,
      Position.forward => 15,
      Position.midfielder => 10,
      Position.defender => 5,
      _ => 0,
    };
    bool canPress = ((tactics?.pressDistance ?? 0) + team.club.tactics.pressDistance + personalPressBonus > ballPos.distance(posXY)) && position != Position.goalKeeper;

    if (canTackle) {
      int tacklePercent = 50;
      int moveBackPercent = 100;
      int ranNum = R().getInt(min: 0, max: tacklePercent + moveBackPercent);

      if (ranNum < tacklePercent && fixture.playerWithBall != null) {
        tackle(fixture.playerWithBall!, team);
      } else if (ranNum < tacklePercent + moveBackPercent) {
        moveBack();
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
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + frontDistance, 3), maximumDistance: speed / 10);
  }

  moveBack() {
    lastAction = PlayerAction.none;
    double backDistance = -1 * min(9, posXY.y * 0.05);

    _move(targetPosition: PosXY.random(posXY.x, posXY.y + backDistance, 3), maximumDistance: speed / 10);
  }

  dribble(ClubInFixture team) {
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + 15, 10), maximumDistance: speed / 10);
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

    nearOpponentAtTarget.sort((a, b) => a.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) - b.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) > 0 ? 1 : -1);

    double targetDistance = target.posXY.distance(ballLandingPos);
    hasBall = false;
    if (nearOpponentAtTarget.isEmpty || targetDistance < nearOpponentAtTarget.first.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y))) {
      passSuccess++;
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

    double distanceBonus = goalKeeper.posXY.distance(PosXY(
      100 - posXY.x,
      200 - posXY.y,
    ));

    if ((overall / (goalKeeper.overall * distanceBonus + overall)) > R().getDouble(max: 1)) {
      goal++;
      fixture.scored(
        scoredClub: team,
        concedeClub: opponent,
        scoredPlayer: this,
        assistPlayer: team.club.startPlayers[1],
      );
    }
  }

  tackle(Player targetPlayer, ClubInFixture team) {
    double distanceBonus = targetPlayer.posXY.distance(PosXY(
          100 - posXY.x,
          200 - posXY.y,
        )) /
        7;

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

    _move(targetPosition: PosXY(ballPositionX, ballPositionY), maximumDistance: speed / 10);
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

    ///ignoreBoundary가 true이면 평소 boundary보다 10정도 여유를둠
    PosXY newPos = PosXY((posXY.x + travelX).clamp(_posXMinBoundary, _posXMaxBoundary), (posXY.y + travelY).clamp(_posYMinBoundary, _posYMaxBoundary));

    double moveDistance = newPos.distance(posXY);

    if (_currentStamina > 30) {
      _currentStamina -= moveDistance / stat.stamina;
    } else {
      _currentStamina *= 0.95;
    }

    posXY = newPos;
  }
}
