import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.location,
    required this.inventory,
  }) : super(
          type: NodeType.headquarters,
          constructionDrones: [Drone.construction()],
          logisticDrones: [Drone.logistic()],
        );

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state.constructions.isNotEmpty &&
        (constructionDrones.isNotEmpty)) {
      for (final Construction construction in game.state.constructions) {
        _checkConstruction(
          construction: construction,
          resource: const Resource(ResourceType.iron_block, 1),
        );

        if (constructionDrones.isEmpty) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: const Resource(ResourceType.copper_block, 1),
        );

        if (constructionDrones.isEmpty) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: const Resource(ResourceType.steel, 1),
        );

        if (constructionDrones.isEmpty) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: const Resource(ResourceType.concrete, 1),
        );

        if (constructionDrones.isEmpty) {
          break;
        }
      }
    }
  }

  @override
  void receiveDone(Drone drone) {
    if (drone.isConstruction) {
      constructionDrones.add(drone);
    } else if (drone.isLogistic) {
      logisticDrones.add(drone);
    }
  }

  void _checkConstruction({
    required Construction construction,
    required Resource resource,
  }) {
    if ((constructionDrones.isNotEmpty) &&
        (construction.remainingResources.hasResource(resource)) &&
        inventory.hasResource(resource)) {
      _sendConstructionDrone(
        construction: construction,
        resource: resource,
      );
    }
  }

  void _sendConstructionDrone({
    required Construction construction,
    required Resource resource,
  }) {
    inventory.removeResource(resource);

    final Drone drone = constructionDrones.removeAt(0);
    drone.load(resource);

    sendDrone(
      drone: drone,
      waypoints: [construction, this],
    );
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );
}
