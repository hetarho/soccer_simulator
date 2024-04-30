abstract class Jsonable {
  Map<String, dynamic> toJson();
  Jsonable.fromJson(Map<String, dynamic> map);
}
