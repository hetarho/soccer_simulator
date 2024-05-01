import 'package:hive_flutter/hive_flutter.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';

class DbManager<T extends Jsonable> {
  final String boxName;

  DbManager(this.boxName);

  add(T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = await Hive.openBox(boxName);
    await box.add(json);
    await box.close();
  }

  put(String key, T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = await Hive.openBox(boxName);
    await box.put(key, json);
    await box.close();
  }

  get(String key) async {
    Box box = await Hive.openBox(boxName);
    var data = await box.get(key);
    await box.close();
    return data;
  }

  getAll() async {
    Box box = await Hive.openBox(boxName);
    List data = box.values.toList();
    await box.close();
    return data;
  }

  delete(String key) async {
    Box box = await Hive.openBox(boxName);
    var data = await box.delete(key);
    await box.close();
    return data;
  }
}
