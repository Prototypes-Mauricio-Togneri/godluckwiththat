import 'package:flutter/rendering.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/nodes/power_plant.dart';
import 'package:tensionnode/types/node_type.dart';

class Nodes {
  num energyProduced = 0;
  num energyConsumed = 0;
  final List<Node> _nodes = [];

  Headquarters get headquarters => at(Offset.zero)! as Headquarters;

  void create({
    required NodeType type,
    required Offset position,
  }) {
    if (type == NodeType.power_plant) {
      final PowerPlant powerPlant = PowerPlant(
        position: position,
        hp: Constants.POWER_PLANT_MAX_HP,
      );
      add(powerPlant);
    }
  }

  void destroy(Node node) {
    _nodes.remove(node);
  }

  T add<T extends Node>(T element) {
    _nodes.add(element);

    energyConsumed = getEnergyConsumed();
    energyProduced = getEnergyProduced();

    return element;
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
