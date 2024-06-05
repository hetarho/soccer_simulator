import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorJsonConverter implements JsonConverter<Color, int> {
  const ColorJsonConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
