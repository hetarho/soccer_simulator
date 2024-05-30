class PlayerGameRecord {
  late int goal;
  late int assist;
  late int passTry;
  late int passSuccess;
  late int intercept;
  late int shooting;
  late int shootOnTarget;
  late int defSuccess;
  late int saveSuccess;
  late int dribbleSuccess;
  PlayerGameRecord({
    required this.goal,
    required this.assist,
    required this.passTry,
    required this.passSuccess,
    required this.intercept,
    required this.shooting,
    required this.shootOnTarget,
    required this.defSuccess,
    required this.saveSuccess,
    required this.dribbleSuccess,
  });

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'assist': assist,
      'passTry': passTry,
      'passSuccess': passSuccess,
      'intercept': intercept,
      'shooting': shooting,
      'shootOnTarget': shootOnTarget,
      'defSuccess': defSuccess,
      'saveSuccess': saveSuccess,
      'dribbleSuccess': dribbleSuccess,
    };
  }

  PlayerGameRecord.fromJson(Map<dynamic, dynamic> map) {
    goal = map['goal'];
    assist = map['assist'];
    passTry = map['passTry'];
    passSuccess = map['passSuccess'];
    intercept = map['intercept'];
    shooting = map['shooting'];
    shootOnTarget = map['shootOnTarget'];
    defSuccess = map['defSuccess'];
    saveSuccess = map['saveSuccess'];
    dribbleSuccess = map['dribbleSuccess'];
  }

  PlayerGameRecord.init() {
    goal = 0;
    assist = 0;
    passSuccess = 0;
    intercept = 0;
    passTry = 0;
    shooting = 0;
    shootOnTarget = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
  }
}
