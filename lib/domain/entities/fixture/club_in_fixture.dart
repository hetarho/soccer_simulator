import 'package:soccer_simulator/domain/entities/club.dart';
import 'package:soccer_simulator/domain/entities/dbManager/jsonable_interface.dart';

class ClubInFixture implements Jsonable {
  late final Club club;
  int _scoredGoal = 0;
  int hasBallTime = 0;
  int shoot = 0;
  int pass = 0;
  int tackle = 0;
  int dribble = 0;

  score() {
    _scoredGoal += 1;
    club.gf++;
  }

  concede() {
    club.ga++;
  }

  get goal {
    return _scoredGoal;
  }

  ClubInFixture({
    required this.club,
  });

  ClubInFixture.empty() {
    club = Club.empty();
  }

  ClubInFixture.fromJson(Map<dynamic, dynamic> map, this.club) {
    _scoredGoal = map['_scoredGoal'];
    hasBallTime = map['hasBallTime'];
    shoot = map['shoot'];
    pass = map['pass'];
    tackle = map['tackle'];
    dribble = map['dribble'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'club': club.toJson(),
      '_scoredGoal': _scoredGoal,
      'hasBallTime': hasBallTime,
      'shoot': shoot,
      'pass': pass,
      'tackle': tackle,
      'dribble': dribble,
    };
  }
}
