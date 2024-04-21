enum PlayerRole {
  forward,
  midfielder,
  defender,
  goalKeeper,
}

enum Position {
  ///fw
  st,
  cf,
  lf,
  rf,
  lw,
  rw,

  ///mf
  lm,
  rm,
  cm,
  am,
  dm,

  ///df
  lb,
  cb,
  rb,

  ///gk
  gk,
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