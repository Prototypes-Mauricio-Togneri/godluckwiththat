import 'package:flutter/widgets.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/resource_type.dart';

class Connection {
  final Node to;
  final ResourceType? resourceType;

  const Connection({
    required this.to,
    this.resourceType,
  });

  Offset get position => to.position;

  Direction directionFrom(Offset position) {
    final num x = position.dx - to.position.dx;
    final num y = position.dy - to.position.dy;

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
