import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Collisionable {
  static const bool render = true;

  static ShapeHitbox polygon({
    required Vector2 parentSize,
    required List<Vector2> points,
  }) {
    return PolygonHitbox.relative(
      points,
      parentSize: parentSize,
    )
      ..renderShape = render
      ..isSolid = true
      ..paint = Paint()
      ..setColor(const Color(0x8000ff00));
  }

  static ShapeHitbox circle(Vector2 parentSize) {
    return CircleHitbox.relative(
      1,
      parentSize: parentSize,
    )
      ..renderShape = render
      ..isSolid = true
      ..paint = Paint()
      ..setColor(const Color(0x8000ff00));
  }

  static ShapeHitbox square(Vector2 parentSize) {
    return RectangleHitbox.relative(
      Vector2(1, 1),
      parentSize: parentSize,
    )
      ..renderShape = render
      ..isSolid = true
      ..paint = Paint()
      ..setColor(const Color(0x8000ff00));
  }

  static ShapeHitbox rectangle({
    required Vector2 parentSize,
    required Vector2 relation,
  }) {
    return RectangleHitbox.relative(
      relation,
      parentSize: parentSize,
    )
      ..renderShape = render
      ..isSolid = true
      ..paint = Paint()
      ..setColor(const Color(0x8000ff00));
  }
}
