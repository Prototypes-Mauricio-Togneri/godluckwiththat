import 'dart:math';

import 'package:flame/components.dart';
import 'package:tensionnode/extensions/random_extension.dart';

enum Direction {
  up,
  down,
  left,
  right;

  Vector2 get vector {
    switch (this) {
      case Direction.up:
        return Vector2(0, -1);
      case Direction.down:
        return Vector2(0, 1);
      case Direction.left:
        return Vector2(-1, 0);
      case Direction.right:
        return Vector2(1, 0);
    }
  }

  Vector2 get randomStartPoint {
    final Random random = Random();
    const int limit = 15;

    switch (this) {
      case Direction.up:
        return Vector2(
            random.between(-limit, limit).toDouble(), limit.toDouble());
      case Direction.down:
        return Vector2(
            random.between(-limit, limit).toDouble(), -limit.toDouble());
      case Direction.left:
        return Vector2(
            limit.toDouble(), random.between(-limit, limit).toDouble());
      case Direction.right:
        return Vector2(
            -limit.toDouble(), random.between(-limit, limit).toDouble());
    }
  }

  static Direction random() =>
      Direction.values[Random().between(0, Direction.values.length)];
}
