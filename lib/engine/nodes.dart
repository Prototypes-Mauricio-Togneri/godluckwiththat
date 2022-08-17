import 'package:flutter/rendering.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/nodes/power_plant.dart';

class Nodes {
  final List<Node> _nodes = [];

  Headquarters get headquarters => at(Offset.zero)! as Headquarters;

  T add<T extends Node>(T element) {
    _nodes.add(element);

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

  int energyConsumed() {
    int energy = 0;

    for (final Node node in _nodes) {
      energy += node.energyConsumed;
    }

    return energy;
  }

  int energyProduced() {
    int energy = 0;

    for (final Node node in _nodes) {
      if (node is PowerPlant) {
        energy += Constants.POWER_PLANT_ENERGY;
      }
    }

    return energy;
  }
}
