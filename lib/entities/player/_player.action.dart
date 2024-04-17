part of 'player.dart';

extension _PlayerMove on Player {
  move(double distance, [double frontAdditional = 0]) {
    double frontDistance = switch (position) {
      Position.forward => 16,
      Position.midfielder => 15,
      Position.defender => (startingPoxXY.x - 50).abs() > 25 ? 24 : 12,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double backDistance = switch (position) {
      Position.forward => 5,
      Position.midfielder => 7,
      Position.defender => 2,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double horizontalDistance = switch (position) {
      Position.forward => 5,
      Position.midfielder => 4.5,
      Position.defender => 2.5,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double ranNum = R().getDouble(min: -3, max: 3);

    double minX = max(0, startingPoxXY.x - 2 * horizontalDistance + ranNum);
    double maxX = min(100, startingPoxXY.x + 2 * horizontalDistance + ranNum);
    double minY = max(0, startingPoxXY.y - 4 * backDistance + ranNum);
    double maxY = min(200, startingPoxXY.y + 7 * frontDistance + ranNum);

    posXY = PosXY(
      (posXY.x + R().getDouble(min: -1 * distance, max: distance)).clamp(minX, maxX),
      (posXY.y + R().getDouble(min: -1 * distance, max: distance) + frontAdditional).clamp(minY, maxY),
    );
  }

  stayFront() {
    double frontDistance = switch (position) {
      Position.forward => 4,
      Position.midfielder => 3,
      Position.defender => 2,
      _ => 0,
    };
    move(5, frontDistance);
  }

  moveFront() {
    double frontDistance = switch (position) {
      Position.forward => 16,
      Position.midfielder => 12,
      Position.defender => 8,
      _ => 0,
    };
    move(12, frontDistance);
  }

  stayBack() {
    double backDistance = switch (position) {
      Position.forward => -1,
      Position.midfielder => -3,
      Position.defender => -6,
      _ => 0,
    };

    move(5, backDistance);
  }

  dribble(ClubInFixture team, int dribbleBonus) {
    lastAction = PlayerAction.dribble;
    move(9, 12 * 1.1);
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

    nearOppositeAtTarget.sort((a, b) => a.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) -
                b.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y)) >
            0
        ? 1
        : -1);

    double targetDistance = target.posXY.distance(ballLandingPos);
    hasBall = false;
    if (nearOppositeAtTarget.isEmpty ||
        targetDistance <
            nearOppositeAtTarget.first.posXY.distance(PosXY(100 - ballLandingPos.x, 200 - ballLandingPos.y))) {
      passSuccess++;
      target.hasBall = true;
      team.pass += 1;
    } else {
      print('intercept!');
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

  press(PosXY target) {
    double targetX = 100 - target.x;
    double targetY = 200 - target.y;

    double diffX = (targetX - posXY.x);
    double diffY = (targetY - posXY.y);

    double distanceToTarget = PosXY(targetX, targetY).distance(posXY);

    double distanceCanForward = min(distanceToTarget, 10);

    double sin = diffY / distanceToTarget;
    double cos = diffX / distanceToTarget;

    double distanceCanForwardX = distanceCanForward * cos;
    double distanceCanForwardY = distanceCanForward * sin;

    posXY = PosXY((posXY.x + distanceCanForwardX).clamp(0, 100), (posXY.y + distanceCanForwardY).clamp(0, 200));
  }
}
