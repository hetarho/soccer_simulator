import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/enum/play_style.enum.dart';

class Coach extends Member implements Jsonable {
  Coach({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.playStyle,
  });

  late final PlayStyle playStyle;

  Coach.fromJson(Map<dynamic, dynamic> map)
      : super(
          birthDay: map['birthDay'],
          name: map['name'],
          national: map['national'],
        ) {
    playStyle = PlayStyle.fromString(map['playStyle']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDay': birthDay,
      'national': national,
      'playStyle': playStyle.toString(),
    };
  }
}
