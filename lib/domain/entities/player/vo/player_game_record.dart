class PlayerGameRecord {
  int goal;
  int assist;
  int passTry;
  int passSuccess;
  int intercept;
  int shooting;
  int shootOnTarget;
  int defSuccess;
  int saveSuccess;
  int dribbleSuccess;
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

  PlayerGameRecord.init()
      : goal = 0,
        assist = 0,
        passSuccess = 0,
        intercept = 0,
        passTry = 0,
        shooting = 0,
        shootOnTarget = 0,
        defSuccess = 0,
        saveSuccess = 0,
        dribbleSuccess = 0;
}
