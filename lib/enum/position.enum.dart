enum PlayerRole {
  forward,
  midfielder,
  defender,
  goalKeeper,
}

enum Position {
  ///fw
  st('st'),
  cf('cf'),
  lf('lf'),
  rf('rf'),
  lw('lw'),
  rw('rw'),

  ///mf
  lm('lm'),
  rm('rm'),
  cm('cm'),
  am('am'),
  dm('dm'),

  ///df
  lb('lb'),
  cb('cb'),
  rb('rb'),

  ///gk
  gk('gk');

  final String text;
  const Position(this.text);

  // 문자열을 Position 열거형으로 변환하는 함수
  static Position fromString(String str) {
    return Position.values.firstWhere((val) => val.text == str, orElse: () => throw ArgumentError('Invalid Position string: $str'));
  }

  @override
  String toString() => text;
}

// Position.st;
// Position.cf;
// Position.lf;
// Position.rf;
// Position.lw;
// Position.rw;
// Position.lm;
// Position.rm;
// Position.cm;
// Position.am;
// Position.dm;
// Position.lb;
// Position.cb;
// Position.rb;
// Position.gk;

// switch (position) {

//       Position.st => base,
//       Position.cf => base,
//       Position.lf => base,
//       Position.rf => base,
//       Position.lw => base,
//       Position.rw => base,
//       Position.lm => base,
//       Position.rm => base,
//       Position.cm => base,
//       Position.am => base,
//       Position.dm => base,
//       Position.lb => base,
//       Position.cb => base,
//       Position.rb => base,
//       Position.gk => base,
//     }