import 'package:flutter/widgets.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/types/direction.dart';

extension OffsetExtension on Offset {
  JsonLocation get json => [dx.toInt(), dy.toInt()];

  bool isAlignedWith(Offset offset) =>
      (offset != this) && ((offset.dx == dx) || (offset.dy == dy));

  bool sameX(Offset offset) => offset.dx == dx;

  bool sameY(Offset offset) => offset.dy == dy;

  int yIncrement(Offset offset) =>
      (offset.dy.toInt() - dy.toInt()) ~/
      (offset.dy.toInt() - dy.toInt()).abs();

  int yDiff(Offset offset) => (offset.dy.toInt() - dy.toInt()).abs();

  int xIncrement(Offset offset) =>
      (offset.dx.toInt() - dx.toInt()) ~/
      (offset.dx.toInt() - dx.toInt()).abs();

  int xDiff(Offset offset) => (offset.dx.toInt() - dx.toInt()).abs();

  Direction directionTo(Offset to) {
    final num x = dx - to.dx;
    final num y = dy - to.dy;

    if ((x == 0) && (y > 0)) {
      return Direction.up;
    } else if ((x == 0) && (y < 0)) {
      return Direction.down;
    } else if ((x > 0) && (y == 0)) {
      return Direction.left;
    } else if ((x < 0) && (y == 0)) {
      return Direction.right;
    } else {
      throw Error();
    }
  }
}
