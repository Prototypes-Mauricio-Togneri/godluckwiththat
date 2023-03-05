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
          logisticDrones: [
            Drone.logistic(),
            Drone.logistic(),
            Drone.logistic(),
            Drone.logistic(),
          ],
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state.constructions.isNotEmpty && hasConstructionDrones) {
      for (final Construction construction in game.state.constructions) {
        _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.iron_block),
        );

        if (!hasConstructionDrones) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.copper_block),
        );

        if (!hasConstructionDrones) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.steel),
        );

        if (!hasConstructionDrones) {
          break;
        }

        _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.concrete),
        );

        if (!hasConstructionDrones) {
          break;
        }
      }
    }
  }

  @override
  void receiveDrone(Drone drone) {
    final Resource? resource = drone.unload();

    if (resource != null) {
      inventory.addResource(resource);
    }
  }

  void _checkConstruction({
    required Construction construction,
    required Resource resource,
  }) {
    if (hasConstructionDrones &&
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

    final Drone drone = getConstructionDrone();
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
