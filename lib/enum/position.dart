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

  @override
  String toString() => text;
}

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