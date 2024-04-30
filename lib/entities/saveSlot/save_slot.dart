import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/league/league.dart';
import 'package:uuid/uuid.dart';

class SaveSlot implements Jsonable {
  late final String id;
  late final DateTime date;
  late final League league;
  late final Club club;

  SaveSlot({required this.date, required this.league, required this.club}) {
    id = const Uuid().v4();
  }

  SaveSlot.empty();

  SaveSlot.fromJson(Map<dynamic, dynamic> map) {
    date = map['date'];
    league = League.fromJson(map['league']);
    club = Club.fromJson(map['club']);
    id = map['id'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'league': league.toJson(),
      'club': club.toJson(),
      'id': id,
    };
  }
}
