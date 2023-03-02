import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/drone.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class Construction extends Node {
  final Inventory remainingResources = Inventory();

  Construction({
    required super.type,
    required super.location,
  });

  @override
  Future onLoad() {
    opacity = 0.5;

    for (final MapEntry<ResourceType, int> entry in type.cost.entries) {
      remainingResources.addResource(Resource(
        entry.key,
        entry.value,
      ));
    }

    return super.onLoad();
  }

  @override
  void receive(Drone drone) {
    final Resource resource = drone.resource;

    remainingResources.removeResource(Resource(
      resource.type,
      resource.amount,
    ));

    if (remainingResources.isEmpty) {
      destroy();
      final Node node = game.buildNode(
        location: location,
        type: type,
      );
      game.selectNode(node);
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
