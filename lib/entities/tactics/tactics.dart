import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/enum/play_level.enum.dart';

class Tactics implements Jsonable {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
    required this.shortPassLevel,
  });
  Tactics.normal({
    this.pressDistance = 10,
    this.attackLevel = PlayLevel.middle,
    this.shortPassLevel = PlayLevel.middle,
  }) {
    freeLevel = FreeLevel.normal();
  }

  late final double pressDistance;
  late final FreeLevel freeLevel;
  late final PlayLevel attackLevel;
  late final PlayLevel shortPassLevel;

  Tactics.fromJson(Map<dynamic, dynamic> map) {
    pressDistance = map['pressDistance'];
    freeLevel = FreeLevel.fromJson(map['freeLevel']);
    attackLevel = PlayLevel.fromString(map['attackLevel']);
    shortPassLevel = PlayLevel.fromString(map['shortPassLevel']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'pressDistance': pressDistance,
      'freeLevel': freeLevel.toJson(),
      'attackLevel': attackLevel.toString(),
      'shortPassLevel': shortPassLevel.toString(),
    };
  }
}

class FreeLevel implements Jsonable {
  late final PlayLevel forward;
  late final PlayLevel backward;
  late final PlayLevel left;
  late final PlayLevel right;

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
