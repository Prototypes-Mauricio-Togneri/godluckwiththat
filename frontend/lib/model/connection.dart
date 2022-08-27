import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/resource_type.dart';

class Connection {
  final Node _from;
  final Node _to;
  ResourceType? _resourceType;
  num _accumulatedTime = 0;

  Connection(this._from, this._to);

  Offset get position => _to.position;

  bool get isAvailable => _resourceType == null;

  bool get isBusy => _resourceType != null;

  Direction get direction {
    final num x = _from.position.dx - _to.position.dx;
    final num y = _from.position.dy - _to.position.dy;

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

  bool goesTo(Node node) => _to == node;

  void send(ResourceType type) {
    _accumulatedTime = 0;
    _resourceType = type;
  }

  void update(double dt) {
    if (isBusy) {
      _accumulatedTime += dt;

      if (_accumulatedTime >= Constants.CONNECTION_PROCESS_TIME) {
        _accumulatedTime = 0;
        _to.addResource(_resourceType!);
        _resourceType = null;
      }
    }
  }

  void render(Renderer renderer) {
    if (_resourceType != null) {
      Offset middlePosition = _from.position;

      switch (direction) {
        case Direction.up:
          middlePosition = middlePosition.translate(0, -0.5);
          break;
        case Direction.down:
          middlePosition = middlePosition.translate(0, 0.5);
          break;
        case Direction.left:
          middlePosition = middlePosition.translate(-0.5, 0);
          break;
        case Direction.right:
          middlePosition = middlePosition.translate(0.5, 0);
          break;
      }

      final String text = (_resourceType != null) ? (_resourceType!.index + 1).toString() : '0';

      renderer.renderText(
        text: text,
        color: Colors.pink,
        size: 5,
        position: middlePosition,
        weight: FontWeight.bold,
      );
    }
  }
}
