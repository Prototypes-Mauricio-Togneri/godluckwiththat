import 'package:flutter/material.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/model/connection.dart';
import 'package:tensionnode/types/direction.dart';
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

  bool get canHaveConnection =>
      (type == NodeType.intersection) || (type == NodeType.mine);

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

  String get connectionsTo {
    String text = '';

    if (top != null) {
      text += '\ntop: ${top!.position.dx},${top!.position.dy}';
    }

    if (bottom != null) {
      text += '\nbottom: ${bottom!.position.dx},${bottom!.position.dy}';
    }

    if (right != null) {
      text += '\nright: ${right!.position.dx},${right!.position.dy}';
    }

    if (left != null) {
      text += '\nleft: ${left!.position.dx},${left!.position.dy}';
    }

    return text;
  }

  void connectTo(Node node) {
    final Direction direction = position.directionTo(node.position);

    switch (direction) {
      case Direction.up:
        top = Connection(this, node);
        break;
      case Direction.down:
        bottom = Connection(this, node);
        break;
      case Direction.left:
        left = Connection(this, node);
        break;
      case Direction.right:
        right = Connection(this, node);
        break;
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

  void repair() {
    hp = maxHp;
  }

  ResourceType? getResourceType() => null;

  JsonNode get json => JsonNode(
        type: type,
        hp: hp,
        resource: getResourceType(),
        position: position.json,
        top: top?.position.json,
        bottom: bottom?.position.json,
        left: left?.position.json,
        right: right?.position.json,
      );
}
