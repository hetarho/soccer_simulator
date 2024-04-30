import 'package:flutter/material.dart';

extension ColorToMapper on Color {
  Map<String, dynamic> toJson() {
    return {
      'red': red,
      'green': green,
      'blue': blue,
    };
  }
}
