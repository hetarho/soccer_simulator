import 'package:soccer_simulator/entities/club.dart';

class Fixture {
  final Club homeClub;
  final Club awayClub;

  int playTime = 0;
  int homeTeamBallPercentage = 100;

  Fixture({required this.homeClub, required this.awayClub});
}
