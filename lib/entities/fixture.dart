import 'package:soccer_simulator/entities/club.dart';

class Fixture {
  final Club homeClub;
  final Club awayClub;
  bool isplayed = false;
  int homeTeamBallPercentage = 100;

  Fixture({required this.homeClub, required this.awayClub});
}
