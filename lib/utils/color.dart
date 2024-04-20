import 'dart:math';

import 'package:flutter/material.dart';

class C {
  double colorDifference(Color color1, Color color2) {
    int r1 = color1.red;
    int g1 = color1.green;
    int b1 = color1.blue;

    int r2 = color2.red;
    int g2 = color2.green;
    int b2 = color2.blue;

    int rDiff = r1 - r2;
    int gDiff = g1 - g2;
    int bDiff = b1 - b2;

    return sqrt(pow(rDiff, 2) + pow(gDiff, 2) + pow(bDiff, 2));
  }
}
