import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class Construction extends Node {
  final Inventory requestedResources = Inventory({});
  final Inventory remainingResources = Inventory({});

  Construction({
    required super.type,
    required super.location,
  }) : super(
          inventory: Inventory({}),
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  Future onLoad() {
    opacity = 0.5;

    for (final MapEntry<ResourceType, int> entry in type.cost.entries) {
      final Resource resource = Resource(
        entry.key,
        entry.value,
      );

      requestedResources.addResource(resource);
      remainingResources.addResource(resource);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    double received = 0;
    double total = 0;

    for (final MapEntry<ResourceType, int> entry in type.cost.entries) {
      received += entry.value - remainingResources.get(entry.key);
      total += entry.value;
    }

    debugText.text = '${((received / total) * 100).toInt()}%';
  }

  @override
  void receiveDrone(Drone drone) {
    final Resource? resource = drone.unload();

    if (resource != null) {
      remainingResources.removeResource(Resource(
        resource.type,
        resource.amount,
      ));
    }

    if (remainingResources.isEmpty) {
      destroy(false);
      final Node node = game.buildNode(
        location: location,
        type: type,
      );
      if (game.isNodeSelected(this)) {
        game.selectNode(node);
      }
      game.sendInitialDrone(node);
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
