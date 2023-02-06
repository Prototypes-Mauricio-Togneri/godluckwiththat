import 'package:flame/components.dart';

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
}
