part of 'player.dart';

extension PlayerMove on Player {
  actionWithOutBall({
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required Fixture fixture,
  }) {
    PosXY ballPos = PosXY(100 - ball.posXY.x, 200 - ball.posXY.y);
    bool canTackle = ballPos.distance(posXY) < 7;

    double personalPressBonus = switch (position) {
      Position.forward when ballPos.y > posXY.y => 100,
      Position.forward => 15,
      Position.midfielder => 10,
      Position.defender => 5,
      _ => 0,
    };
    bool canPress = (team.club.tactics.pressDistance + personalPressBonus > ballPos.distance(posXY)) && position != Position.goalKeeper;

    if (canTackle) {
      int tacklePercent = 50;
      int stayBackPercent = 100;
      int ranNum = R().getInt(min: 0, max: tacklePercent + stayBackPercent);

      if (ranNum < tacklePercent) {
        tackle(fixture.playerWithBall!, team);
      } else if (ranNum < tacklePercent + stayBackPercent) {
        stayBack();
      }
    } else {
      if (canPress) {
        press(ball.posXY);
      } else {
        stayBack();
      }
    }
  }

  actionWidthBall({
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required Fixture fixture,
  }) {
    List<Player> teamPlayers = [...team.club.players.where((p) => p.id != id)];
    List<Player> oppositePlayers = opposite.club.players;

    if (hasBall) {
      teamPlayers.sort((a, b) => a.posXY.distance(posXY) - b.posXY.distance(posXY) > 0 ? 1 : -1);
      int shootPercent = max(0, ((2500 - pow(PosXY(50, 200).distance(posXY), 2))).round());
      int passPercent = 250;

      int dribbleBonus =
          (11 - oppositePlayers.where((opposite) => ((100 - opposite.posXY.x + 15) > posXY.x && (100 - opposite.posXY.x - 15) < posXY.x) || (200 - opposite.posXY.y - posXY.y) > 50).length);
      int dribblePercent = position == Position.goalKeeper ? 0 : (50 + dribbleBonus * 100);
      int ranNum = R().getInt(min: 0, max: shootPercent + passPercent + dribblePercent);
      List<Player> frontPlayers = teamPlayers.where((p) => p.posXY.y > posXY.y - 30).toList();

      List<Player> nearOpposite = oppositePlayers
          .where((opposite) =>
              opposite.posXY.distance(PosXY(
                100 - posXY.x,
                200 - posXY.y,
              )) <
              10)
          .toList();

      bool canShoot = true;

      for (var opposite in nearOpposite) {
        double distanceBonus = 10 -
            opposite.posXY.distance(PosXY(
              100 - posXY.x,
              200 - posXY.y,
            ));

        if ((overall / (opposite.overall * distanceBonus + overall)) < R().getDouble(max: 1)) {
          canShoot = false;
        }
      }

      if (canShoot && (ranNum < shootPercent || (posXY.y > 180 && frontPlayers.isEmpty))) {
        shoot(fixture: fixture, team: team, opposite: opposite, goalKeeper: oppositePlayers.firstWhere((player) => player.position == Position.goalKeeper));
      } else if (ranNum < shootPercent + passPercent) {
        late Player target;
        if (ball.posXY.y >= 100 && frontPlayers.isNotEmpty) {
          target = frontPlayers[R().getInt(min: 0, max: frontPlayers.length - 1)];
        } else if (ball.posXY.y >= 50) {
          target = R().getInt(max: 10, min: 0) > 1 ? teamPlayers[R().getInt(min: 0, max: 1)] : teamPlayers[R().getInt(min: 7, max: 9)];
        } else {
          target = R().getInt(max: 10, min: 0) > 3 ? teamPlayers[R().getInt(min: 0, max: 2)] : teamPlayers[R().getInt(min: 5, max: 7)];
        }

        List<Player> nearOppositeAtTarget = oppositePlayers
            .where((opposite) =>
                opposite.posXY.distance(PosXY(
                  100 - target.posXY.x,
                  200 - target.posXY.y,
                )) <
                15)
            .toList();

        // print(nearOppositeAtTarget.length);

        pass(target, team, nearOppositeAtTarget, fixture);
      } else if (ranNum < shootPercent + passPercent + dribblePercent) {
        dribble(team, dribbleBonus);
      }
    } else {
      int ranNum = R().getInt(min: 0, max: 100);
      switch (ranNum) {
        case < 40:
          stayFront();
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

  double get posXMinBoundary {
    return max(startingPoxXY.x - 20, 0);
  }

  double get posXMaxBoundary {
    return min(startingPoxXY.x + 20, 100);
  }

  double get posYMinBoundary {
    return max(startingPoxXY.y - 20, 0);
  }

  double get posYMaxBoundary {
    bool isWinger = posXY.x < 30 || posXY.x > 70;

    return switch (position) {
      Position.goalKeeper => startingPoxXY.y + 10,
      Position.defender => startingPoxXY.y + (isWinger ? 150 : 40),
      Position.midfielder => startingPoxXY.y + (isWinger ? 120 : 55),
      Position.forward => startingPoxXY.y + (isWinger ? 100 : 100),
      _ => min(startingPoxXY.y + 200, 200),
    };
  }

  stayFront() {
    lastAction = PlayerAction.none;
    double frontDistance = switch (position) {
      Position.forward => 4,
      Position.midfielder => 3,
      Position.defender => 2,
      _ => 0,
    };
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + frontDistance, 5));
  }

  moveFront() {
    lastAction = PlayerAction.none;
    double frontDistance = switch (position) {
      Position.forward => 16,
      Position.midfielder => 12,
      Position.defender => 8,
      _ => 0,
    };
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + frontDistance, 5));
  }

  stayBack() {
    lastAction = PlayerAction.none;
    double backDistance = switch (position) {
      Position.forward => -1,
      Position.midfielder => -3,
      Position.defender => -6,
      _ => 0,
    };

    _move(targetPosition: PosXY.random(posXY.x, posXY.y + backDistance, 5));
  }

  dribble(ClubInFixture team, int dribbleBonus) {
    _move(targetPosition: PosXY.random(posXY.x, posXY.y + 15, 10), maximumDistance: speed / 50);
    lastAction = PlayerAction.dribble;
    dribbleSuccess++;
    team.dribble++;
  }

  pass(Player target, ClubInFixture team, List<Player> nearOppositeAtTarget, Fixture fixture) {
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

    nearOppositeAtTarget.sort((a, b) => a.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) - b.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) > 0 ? 1 : -1);

    double targetDistance = target.posXY.distance(ballLandingPos);
    hasBall = false;
    if (nearOppositeAtTarget.isEmpty || targetDistance < nearOppositeAtTarget.first.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y))) {
      passSuccess++;
      target.hasBall = true;
      team.pass += 1;
    } else {
      nearOppositeAtTarget.first.hasBall = true;
    }
  }

  shoot({
    required Player goalKeeper,
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opposite,
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

    // print('========shoot=========');
    // print('overall:$overall');
    // print('distanceBonus:$distanceBonus');
    // print('m:${goalKeeper.overall * distanceBonus + overall}');
    // print('확률:${(overall * 100 / (goalKeeper.overall * distanceBonus + overall))}%');

    if ((overall / (goalKeeper.overall * distanceBonus + overall)) > R().getDouble(max: 1)) {
      goal++;
      fixture.scored(
        scoredClub: team,
        concedeClub: opposite,
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

    _move(targetPosition: PosXY(ballPositionX, ballPositionY), maximumDistance:  speed / 50, ignoreBoundary: true);
  }

  _move({
    required PosXY targetPosition,
    double? maximumDistance,
    bool ignoreBoundary = false,
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

    posXY = PosXY(
        (posXY.x + travelX).clamp(
          ignoreBoundary ? 0 : posXMinBoundary,
          ignoreBoundary ? 100 : posXMaxBoundary,
        ),
        (posXY.y + travelY).clamp(
          ignoreBoundary ? 0 : posYMinBoundary,
          ignoreBoundary ? 200 : posYMaxBoundary,
        ));
  }
}
