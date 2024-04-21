import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';

Position getPositionFromPosXY(PosXY posXY) {
  Position position;

  //fw
  if (posXY.y > 70) {
    if (posXY.x < 20) {
      position = Position.lw;
    } else if (posXY.x < 35) {
      position = Position.lf;
    } else if (posXY.x <= 55) {
      if (posXY.y > 85) {
        position = Position.st;
      } else {
        position = Position.cf;
      }
    } else if (posXY.x <= 80) {
      position = Position.rf;
    } else {
      position = Position.rw;
    }
  }

  //mf
  else if (posXY.y > 30) {
    if (posXY.x < 30) {
      position = Position.lm;
    } else if (posXY.x < 70) {
      if (posXY.y > 60) {
        position = Position.am;
      } else if (posXY.y > 40) {
        position = Position.cm;
      } else {
        position = Position.dm;
      }
    } else {
      position = Position.rm;
    }
    return position;
  }

  //df
  else if (posXY.y > 1) {
    if (posXY.x < 30) {
      position = Position.lb;
    } else if (posXY.x < 70) {
      position = Position.cb;
    } else {
      position = Position.rb;
    }
  } else {
    position = Position.gk;
  }

  return position;
}

PlayerRole getPlayerRoleFromPosition(Position position) {
  return switch (position) {
    Position.st => PlayerRole.forward,
    Position.cf => PlayerRole.forward,
    Position.lf => PlayerRole.forward,
    Position.rf => PlayerRole.forward,
    Position.lw => PlayerRole.forward,
    Position.rw => PlayerRole.forward,
    Position.lm => PlayerRole.midfielder,
    Position.rm => PlayerRole.midfielder,
    Position.cm => PlayerRole.midfielder,
    Position.am => PlayerRole.midfielder,
    Position.dm => PlayerRole.midfielder,
    Position.lb => PlayerRole.defender,
    Position.cb => PlayerRole.defender,
    Position.rb => PlayerRole.defender,
    Position.gk => PlayerRole.goalKeeper,
  };
}

PlayerRole getPlayerRoleFromPos(PosXY posXY) {
  return getPlayerRoleFromPosition(getPositionFromPosXY(posXY));
}
