import 'package:hive_flutter/hive_flutter.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';

class DbManager<T extends Jsonable> {
  final String boxName;

  DbManager(this.boxName);

  init() async {
    await Hive.openBox(boxName);
  }

  add(T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = Hive.box(boxName);
    await box.add(json);
  }

  put(String key, T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = Hive.box(boxName);
    await box.put(key, json);
  }

  get(String key) async {
    Box box = Hive.box(boxName);
    var data = await box.get(key);
    return data;
  }

  List getAll() {
    Box box = Hive.box(boxName);
    List data = box.values.toList();
    return data;
  }

  delete(String key) async {
    Box box = Hive.box(boxName);
    var data = await box.delete(key);
    return data;
  }
}
