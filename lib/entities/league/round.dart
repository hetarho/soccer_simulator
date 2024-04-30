import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';

class Round implements Jsonable {
  late final List<Fixture> fixtures;
  late final int number;

  get isAllGameEnd {
    return fixtures.fold(true, (pre, curr) => curr.isGameEnd && pre);
  }

  Round({required this.fixtures, required this.number});

  Round.fromJson(Map<dynamic, dynamic> map) {
    fixtures = (map['fixtures'] as List).map((e) => Fixture.fromJson(e)).toList();
    number = map['number'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fixtures': fixtures.map((e) => e.toJson()).toList(),
      'number': number,
    };
  }
}
