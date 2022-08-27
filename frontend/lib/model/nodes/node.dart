import 'package:flutter/material.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/connection.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Node {
  final String id;
  final NodeType type;
  final Offset position;
  final int energyConsumed;
  final List<ResourceType> accumulatedResources = [];
  int nextConnectionIndex = 0;
  num hp;
  num maxHp;
  Connection? top;
  Connection? bottom;
  Connection? left;
  Connection? right;

  Node({
    required this.type,
    required this.position,
    required this.hp,
    required this.maxHp,
    required this.energyConsumed,
  }) : id = '${position.dx},${position.dy}';

  bool get needsRepair => hp < maxHp;

  bool isAt(Offset testPosition) => position == testPosition;

  Connection? get nextConnection {
    nextConnectionIndex = (nextConnectionIndex + 1) % 4;

    if (nextConnectionIndex == 0) {
      return top;
    } else if (nextConnectionIndex == 1) {
      return right;
    } else if (nextConnectionIndex == 2) {
      return bottom;
    } else if (nextConnectionIndex == 3) {
      return left;
    } else {
      return null;
    }
  }

  void addResource(ResourceType type) => accumulatedResources.add(type);

  void removeConnectionTo(Node node) {
    if ((top != null) && top!.goesTo(node)) {
      top = null;
    } else if ((bottom != null) && bottom!.goesTo(node)) {
      bottom = null;
    } else if ((right != null) && right!.goesTo(node)) {
      right = null;
    } else if ((left != null) && left!.goesTo(node)) {
      left = null;
    }
  }

  void fillConnections({
    required Connection? topNode,
    required Connection? bottomNode,
    required Connection? leftNode,
    required Connection? rightNode,
  }) {
    top = topNode;
    bottom = bottomNode;
    left = leftNode;
    right = rightNode;
  }

  @mustCallSuper
  void update(double dt) {
    _updateConnection(top, dt);
    _updateConnection(right, dt);
    _updateConnection(bottom, dt);
    _updateConnection(left, dt);

    if (accumulatedResources.isNotEmpty) {
      for (int i = 0; i < 4; i++) {
        final Connection? connection = nextConnection;

        if ((connection != null) && (connection.isAvailable)) {
          final ResourceType resourceType = accumulatedResources.removeAt(0);
          connection.send(resourceType);
          break;
        }
      }
    }
  }

  void _updateConnection(Connection? connection, double dt) {
    if (connection != null) {
      connection.update(dt);
    }
  }

  @mustCallSuper
  void render(Renderer renderer) {
    if (renderer.hasDebugMode) {
      if (accumulatedResources.isNotEmpty) {
        renderer.renderText(
          text: '${accumulatedResources.length}',
          color: Colors.yellow,
          size: 3,
          position: position,
          weight: FontWeight.bold,
        );
      }

      _renderConnection(top, renderer);
      _renderConnection(right, renderer);
      _renderConnection(bottom, renderer);
      _renderConnection(left, renderer);
    }
  }

  void _renderConnection(Connection? connection, Renderer renderer) {
    if (connection != null) {
      connection.render(renderer);
    }
  }

  void repair() {
    hp = maxHp;
  }

  void drawHP(Renderer renderer) {
    renderer.hp(
      position: position,
      value: hp,
      max: maxHp,
    );
  }

  void renderConnections(Renderer renderer) {
    _renderConnectionTo(
      renderer: renderer,
      connection: top,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: bottom,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: left,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: right,
    );
  }

  void _renderConnectionTo({
    required Renderer renderer,
    required Connection? connection,
  }) {
    if (connection != null) {
      renderer.connection(
        direction: connection.direction,
        from: position,
        to: connection.position,
        lineColor: Palette.connectionLine,
        arrowColor: Palette.connectionArrow,
      );
    }
  }
}
