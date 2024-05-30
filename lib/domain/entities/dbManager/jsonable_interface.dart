abstract class Jsonable {
  Map<String, dynamic> toJson();
  Jsonable.fromJson(Map<dynamic, dynamic> map);
}
