import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Collisionable {
  static ShapeHitbox polygon({
    required Vector2 parentSize,
    required List<Vector2> points,
  }) {
    return PolygonHitbox.relative(
      points,
      parentSize: parentSize,
    )
      //..renderShape = true
      ..isSolid = true
      ..paint = Paint()
      ..setColor(const Color(0x8000ff00));
  }
}
