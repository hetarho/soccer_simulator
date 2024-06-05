// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/domain/entities/fixture/fixture.dart';

class Round {
  Round({required this.id, required this.number});
  final int id;
  final int number;
  List<Fixture> fixtures = [];

  get isAllGameEnd {
    return fixtures.fold(true, (pre, curr) => curr.isGameEnd && pre);
  }
}
