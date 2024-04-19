import 'dart:math';

import 'package:soccer_simulator/entities/pos/pos.dart';

class M {
  /// 두 점을 지나는 직선과 제3의 점과의 거리를 계산합니다.
  /// [linePoint1]: 직선을 정의하는 첫 번째 점
  /// [linePoint2]: 직선을 정의하는 두 번째 점
  /// [point]: 직선으로부터 거리를 측정할 점
  double getDistanceFromPointToLine({
    required PosXY linePoint1,
    required PosXY linePoint2,
    required PosXY point,
  }) {
    // 직선의 방정식 계수 (Ax + By + C = 0)를 계산
    double slopeY = linePoint1.y - linePoint2.y;
    double slopeX = linePoint2.x - linePoint1.x;
    double intercept = -1 * (slopeY * linePoint1.x + slopeX * linePoint1.y);

    // 점-직선 거리 공식을 사용하여 거리 계산
    double numerator = (slopeY * point.x + slopeX * point.y + intercept).abs();
    double denominator = sqrt(pow(slopeY, 2) + pow(slopeX, 2));

    double distance = numerator / denominator;
    return distance;
  }
}
