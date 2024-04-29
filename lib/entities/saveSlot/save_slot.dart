import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/league.dart';

class SaveSlot {
  final DateTime date;
  final League league;
  final Club club;

  SaveSlot({required this.date, required this.league, required this.club});
}
