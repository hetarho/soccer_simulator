import 'package:hive_flutter/hive_flutter.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';

class DbManager<T extends Jsonable> {
  final String boxName;

  DbManager(this.boxName);

  init() async {
    Box box = await Hive.openBox(boxName);
    // await box.clear();

    /// Box가 압축되지 않았을 경우가 있어서 추가
    await box.compact();
  }

  add(T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = Hive.box(boxName);
    await box.add(json);

    /// Box가 압축되지 않았을 경우가 있어서 추가
    await box.compact();
  }

  put(String key, T data) async {
    Map<String, dynamic> json = data.toJson();
    Box box = Hive.box(boxName);
    await box.put(key, json);

    /// Box가 압축되지 않았을 경우가 있어서 추가
    await box.compact();
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

    /// Box가 압축되지 않았을 경우가 있어서 추가
    await box.compact();
    return data;
  }
}
