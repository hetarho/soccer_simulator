part of 'player.dart';

extension _PlayerMove on Player {
  move(double distance, [double frontAdditional = 0]) {
    double frontDistance = switch (position) {
      Position.forward => 12,
      Position.midfielder => 7,
      Position.defender => (startingPoxXY.x - 50).abs() > 25 ? 15 : 3,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double backDistance = switch (position) {
      Position.forward => 3,
      Position.midfielder => 6,
      Position.defender => 10,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double horizontalDistance = switch (position) {
      Position.forward => 4,
      Position.midfielder => 4,
      Position.defender => 3,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double ranNum = R().getDouble(min: -3, max: 3);

    double minX = max(0, startingPoxXY.x - 2.5 * horizontalDistance + ranNum);
    double maxX = min(100, startingPoxXY.x + 2.5 * horizontalDistance + ranNum);
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

    double distanceToTarget = target.distance(posXY);

    double distanceCanForward = switch (position) {
      Position.forward => 7,
      Position.midfielder => 9,
      Position.defender => 12,
      _ => 0,
    };

    double disX = min(distanceCanForward, diffX) * min(1, distanceCanForward / distanceToTarget);
    double disY = min(distanceCanForward, diffY) * min(1, distanceCanForward / distanceToTarget);

    posXY = PosXY((posXY.x + disX).clamp(0, 100), (posXY.y + disY).clamp(0, 200));
  }
}
