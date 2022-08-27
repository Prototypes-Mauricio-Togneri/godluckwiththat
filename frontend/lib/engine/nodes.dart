import 'package:flutter/rendering.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/model/connection.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/heavy_turret.dart';
import 'package:tensionnode/model/nodes/light_turret.dart';
import 'package:tensionnode/model/nodes/mine.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/nodes/power_plant.dart';
import 'package:tensionnode/model/nodes/wall.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Nodes {
  num energyProduced = 0;
  num energyConsumed = 0;
  final List<Node> _nodes = [];

  Headquarters get headquarters => at(Offset.zero)! as Headquarters;

  void create({
    required NodeType type,
    required Offset position,
    required ResourceType? resourceType,
  }) {
    switch (type) {
      case NodeType.intersection:
        // TODO(momo): implement
        break;
      case NodeType.mine:
        _addMine(position: position, resourceType: resourceType);
        break;
      case NodeType.power_plant:
        _addPowerPlant(position);
        break;
      case NodeType.wall:
        _addWall(position);
        break;
      case NodeType.light_turret:
        _addLightTurret(position);
        break;
      case NodeType.heavy_turret:
        _addHeavyTurret(position);
        break;

      default:
    }
  }

  void _addMine({
    required Offset position,
    required ResourceType? resourceType,
  }) {
    if (resourceType != null) {
      final Mine mine = Mine(
        resourceType: resourceType,
        position: position,
        hp: Constants.MINE_MAX_HP,
      );
      add(mine);
    }
  }

  void _addPowerPlant(Offset position) {
    final PowerPlant powerPlant = PowerPlant(
      position: position,
      hp: Constants.POWER_PLANT_MAX_HP,
    );
    add(powerPlant);
  }

  void _addWall(Offset position) {
    final Wall wall = Wall(
      position: position,
      hp: Constants.WALL_MAX_HP,
    );
    add(wall);
  }

  void _addLightTurret(Offset position) {
    final LightTurret wall = LightTurret(
      position: position,
      hp: Constants.LIGHT_TURRET_MAX_HP,
    );
    add(wall);
  }

  void _addHeavyTurret(Offset position) {
    final HeavyTurret wall = HeavyTurret(
      position: position,
      hp: Constants.HEAVY_TURRET_MAX_HP,
    );
    add(wall);
  }

  void destroy(Node node) {
    _nodes.remove(node);

    for (final Node current in _nodes) {
      current.removeConnectionTo(node);
    }

    energyConsumed = getEnergyConsumed();
    energyProduced = getEnergyProduced();
  }

  T add<T extends Node>(T element) {
    _nodes.add(element);

    energyConsumed = getEnergyConsumed();
    energyProduced = getEnergyProduced();

    return element;
  }

  void fillConnections(JsonMatch match) {
    for (final Node node in _nodes) {
      final JsonNode? jsonNode = match.getNode(node.position);

      node.fillConnections(
        topNode: (jsonNode != null) ? _connection(node, jsonNode.top) : null,
        bottomNode: (jsonNode != null) ? _connection(node, jsonNode.bottom) : null,
        leftNode: (jsonNode != null) ? _connection(node, jsonNode.left) : null,
        rightNode: (jsonNode != null) ? _connection(node, jsonNode.right) : null,
      );
    }
  }

  Connection? _connection(Node from, JsonPosition? position) {
    if (position != null) {
      final Node? to = at(position.position);

      if (to != null) {
        return Connection(from, to);
      }
    }

    return null;
  }

  Node? at(Offset position) {
    for (final Node node in _nodes) {
      if (node.isAt(position)) {
        return node;
      }
    }

    return null;
  }

  void update(double dt) {
    for (final Node node in _nodes) {
      node.update(dt);
    }
  }

  void render(Renderer renderer) {
    for (final Node node in _nodes) {
      node.render(renderer);
    }
  }

  void repairAll() {
    for (final Node node in _nodes) {
      node.repair();
    }
  }

  int getEnergyConsumed() {
    int energy = 0;

    for (final Node node in _nodes) {
      energy += node.energyConsumed;
    }

    return energy;
  }

  int getEnergyProduced() {
    int energy = 0;

    for (final Node node in _nodes) {
      if (node is PowerPlant) {
        energy += Constants.POWER_PLANT_ENERGY;
      }
    }

    return energy;
  }
}
