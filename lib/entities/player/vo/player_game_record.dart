// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlayerGameRecord {
  late int goal;
  late int assist;
  late int passTry;
  late int passSuccess;
  late int shooting;
  late int defSuccess;
  late int saveSuccess;
  late int dribbleSuccess;
  PlayerGameRecord({
    required this.goal,
    required this.assist,
    required this.passTry,
    required this.passSuccess,
    required this.shooting,
    required this.defSuccess,
    required this.saveSuccess,
    required this.dribbleSuccess,
  });

  PlayerGameRecord.init() {
    goal = 0;
    assist = 0;
    passSuccess = 0;
    passTry = 0;
    shooting = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
  }
}
