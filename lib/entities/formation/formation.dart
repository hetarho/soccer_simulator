import 'package:soccer_simulator/entities/pos/pos.dart';

class Formation {
  late final List<PosXY> posXYList;

  Formation({required this.posXYList});

  Formation.create433() {
    posXYList = [
      PosXY(25, 90),
      PosXY(50, 90),
      PosXY(75, 90),
      PosXY(25, 60),
      PosXY(50, 60),
      PosXY(75, 60),
      PosXY(15, 30),
      PosXY(40, 30),
      PosXY(60, 30),
      PosXY(85, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create442() {
    posXYList = [
      PosXY(35, 90),
      PosXY(65, 90),
      PosXY(15, 60),
      PosXY(40, 60),
      PosXY(60, 60),
      PosXY(85, 60),
      PosXY(15, 30),
      PosXY(40, 30),
      PosXY(60, 30),
      PosXY(85, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create4222() {
    posXYList = [
      PosXY(40, 90),
      PosXY(60, 90),
      PosXY(15, 70),
      PosXY(85, 70),
      PosXY(40, 50),
      PosXY(60, 50),
      PosXY(15, 30),
      PosXY(40, 30),
      PosXY(60, 30),
      PosXY(85, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create4141() {
    posXYList = [
      PosXY(50, 90),
      PosXY(15, 70),
      PosXY(40, 70),
      PosXY(60, 70),
      PosXY(85, 70),
      PosXY(50, 50),
      PosXY(15, 30),
      PosXY(40, 30),
      PosXY(60, 30),
      PosXY(85, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create41212() {
    posXYList = [
      PosXY(35, 90),
      PosXY(65, 90),
      PosXY(50, 75),
      PosXY(35, 60),
      PosXY(65, 60),
      PosXY(50, 45),
      PosXY(15, 30),
      PosXY(40, 30),
      PosXY(60, 30),
      PosXY(85, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create352() {
    posXYList = [
      PosXY(40, 90),
      PosXY(60, 90),
      PosXY(10, 65),
      PosXY(30, 65),
      PosXY(50, 65),
      PosXY(70, 65),
      PosXY(90, 65),
      PosXY(30, 30),
      PosXY(50, 30),
      PosXY(70, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create532() {
    posXYList = [
      PosXY(40, 90),
      PosXY(60, 90),
      PosXY(30, 65),
      PosXY(50, 65),
      PosXY(70, 65),
      PosXY(10, 30),
      PosXY(30, 30),
      PosXY(50, 30),
      PosXY(70, 30),
      PosXY(90, 30),
      PosXY(50, 0),
    ];
  }

  Formation.create3241() {
    posXYList = [
      PosXY(50, 90),
      PosXY(15, 70),
      PosXY(40, 70),
      PosXY(60, 70),
      PosXY(85, 70),
      PosXY(40, 50),
      PosXY(60, 50),
      PosXY(30, 30),
      PosXY(50, 30),
      PosXY(70, 30),
      PosXY(50, 0),
    ];
  }
}
