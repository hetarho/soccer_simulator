import 'package:json_annotation/json_annotation.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';

class TacticsJsonConverter implements JsonConverter<Tactics, Map<String, dynamic>> {
  const TacticsJsonConverter();

  @override
  Tactics fromJson(Map<String, dynamic> json) => Tactics(
        pressDistance: json['pressDistance'],
        freeLevel: FreeLevel(
          json['freeLevel_forward'],
          json['freeLevel_backward'],
          json['freeLevel_left'],
          json['freeLevel_right'],
        ),
        attackLevel: json['attackLevel'],
        shortPassLevel: json['shortPassLevel'],
        dribbleLevel: json['dribbleLevel'],
        shootLevel: json['shootLevel'],
      );

  @override
  Map<String, dynamic> toJson(Tactics tactics) => {
        'pressDistance': tactics.pressDistance,
        'freeLevel_forward': tactics.freeLevel.forward,
        'freeLevel_backward': tactics.freeLevel.backward,
        'freeLevel_left': tactics.freeLevel.left,
        'freeLevel_right': tactics.freeLevel.right,
        'attackLevel': tactics.attackLevel,
        'shortPassLevel': tactics.shortPassLevel,
        'dribbleLevel': tactics.dribbleLevel,
        'shootLevel': tactics.shootLevel,
      };
}
