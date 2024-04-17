part of 'player.dart';

extension _PlayerMove on Player {
  move(double distance, [double frontAdditional = 0]) {
    double frontDistance = switch (position) {
      Position.forward => 14,
      Position.midfielder => 13,
      Position.defender => (startingPoxXY.x - 50).abs() > 25 ? 18 : 7,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double backDistance = switch (position) {
      Position.forward => 5,
      Position.midfielder => 7,
      Position.defender => 10,
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

  dribble(ClubInFixture team) {
    move(9, 12);
    dribbleSuccess++;
    team.dribble++;
  }

  pass(Player target, ClubInFixture team) {
    passSuccess++;
    hasBall = false;
    target.hasBall = true;
    team.pass += 1;
  }

  shoot({
    required Player goalKeeper,
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opposite,
  }) {
    int ranNum = R().getInt(min: 0, max: 100);
    hasBall = false;
    goalKeeper.hasBall = true;
    team.shoot += 1;
    shooting++;

    if (ranNum < 10) {
      goal++;
      fixture.scored(
        scoredClub: team,
        concedeClub: opposite,
        scoredPlayer: this,
        assistPlayer: team.club.startPlayers[1],
      );
    }
  }

  buildUpPass() {}

  tackle(Player targetPlayer, ClubInFixture team) {
    int ranNum = R().getInt(min: 0, max: 100);
    if (ranNum < 50) {
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
