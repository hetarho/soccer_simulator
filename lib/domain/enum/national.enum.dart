enum National {
  france('france'),
  england('england'),
  unitedStates('unitedStates'),
  southKorea('southKorea'),
  belgium('belgium'),
  brazil('brazil'),
  argentina('argentina'),
  chile('chile'),
  mexico('mexico'),
  germany('germany'),
  japan('japan'),
  ukraine('ukraine'),
  italy('italy'),
  netherlands('netherlands'),
  switzerland('switzerland'),
  greece('greece'),
  poland('poland'),
  austria('austria'),
  sweden('sweden'),
  norway('norway'),
  romania('romania'),
  ireland('ireland'),
  croatia('croatia'),
  finland('finland'),
  czechRepublic('czechRepublic'),
  colombia('colombia'),
  peru('peru'),
  uruguay('uruguay'),
  ecuador('ecuador'),
  paraguay('paraguay'),
  canada('canada'),
  nigeria('nigeria'),
  ghana('ghana'),
  morocco('morocco'),
  senegal('senegal'),
  ivoryCoast('ivoryCoast'),
  algeria('algeria'),
  cameroon('cameroon'),
  togo('togo');

  final String text;
  const National(this.text);

  // 문자열을 National 열거형으로 변환하는 함수
  static National fromString(String levelString) {
    return National.values.firstWhere((level) => level.text == levelString, orElse: () => throw ArgumentError('Invalid National string: $levelString'));
  }

  @override
  String toString() => text;
}
