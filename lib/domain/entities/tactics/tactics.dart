import 'package:soccer_simulator/domain/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/domain/enum/play_level.enum.dart';

class Tactics implements Jsonable {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
    required this.shortPassLevel,
    required this.dribbleLevel,
    required this.shootLevel,
  });
  Tactics.normal({
    this.pressDistance = 25,
    this.attackLevel = PlayLevel.middle,
    this.shortPassLevel = PlayLevel.middle,
    this.dribbleLevel = PlayLevel.middle,
    this.shootLevel = PlayLevel.middle,
  }) {
    freeLevel = FreeLevel.normal();
  }

  late double pressDistance;
  late FreeLevel freeLevel;
  late PlayLevel attackLevel;
  late PlayLevel shortPassLevel;

  ///상황을 드리블로 풀어나가는 비중
  late PlayLevel dribbleLevel;

  ///슛을 신중하게 하는지 여부
  late PlayLevel shootLevel;

  Tactics.fromJson(Map<dynamic, dynamic> map) {
    pressDistance = map['pressDistance'];
    freeLevel = FreeLevel.fromJson(map['freeLevel']);
    attackLevel = PlayLevel.fromString(map['attackLevel']);
    shortPassLevel = PlayLevel.fromString(map['shortPassLevel']);
    dribbleLevel = PlayLevel.fromString(map['dribbleLevel']);
    shootLevel = PlayLevel.fromString(map['shootLevel']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'pressDistance': pressDistance,
      'freeLevel': freeLevel.toJson(),
      'attackLevel': attackLevel.toString(),
      'shortPassLevel': shortPassLevel.toString(),
      'dribbleLevel': dribbleLevel.toString(),
      'shootLevel': shootLevel.toString(),
    };
  }
}

class FreeLevel implements Jsonable {
  late PlayLevel forward;
  late PlayLevel backward;
  late PlayLevel left;
  late PlayLevel right;

  FreeLevel(this.forward, this.backward, this.left, this.right);

  FreeLevel.normal() {
    forward = PlayLevel.middle;
    backward = PlayLevel.middle;
    left = PlayLevel.middle;
    right = PlayLevel.middle;
  }

  FreeLevel.fromJson(Map<dynamic, dynamic> map) {
    forward = PlayLevel.fromString(map['forward']);
    backward = PlayLevel.fromString(map['backward']);
    left = PlayLevel.fromString(map['left']);
    right = PlayLevel.fromString(map['right']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'forward': forward.toString(),
      'backward': backward.toString(),
      'left': left.toString(),
      'right': right.toString(),
    };
  }
}
