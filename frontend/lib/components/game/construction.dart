import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Construction extends Node {
  final ResourceType? resourceType;
  final Inventory remainingResources = Inventory.empty();

  Construction({
    required super.nodeType,
    required super.location,
    required this.resourceType,
  }) : super(
          inventory: Inventory.empty(),
          connections: [],
        );

  @override
  Future onLoad() {
    opacity = 0.5;

    game.state.headquarters.addDroneConnection(this);

    for (final MapEntry<ResourceType, int> entry in nodeType.cost.entries) {
      final Resource resource = Resource(
        entry.key,
        entry.value,
      );

      remainingResources.addResource(resource);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    double received = 0;
    double total = 0;

    for (final MapEntry<ResourceType, int> entry in nodeType.cost.entries) {
      received += entry.value - remainingResources.get(entry.key);
      total += entry.value;
    }

    debugText.text = '${((received / total) * 100).toInt()}%';
  }

  @override
  void receiveResource(Resource resource) {
    remainingResources.removeResource(Resource(
      resource.resourceType,
      resource.amount,
    ));
    updateMenu();

    if (remainingResources.isEmpty) {
      game.state.headquarters.removeDroneConnection(this);
      destroy(false);
      final Node node = game.buildNode(
        location: location,
        nodeType: nodeType,
        resourceType: resourceType,
      );
      if (game.isNodeSelected(this)) {
        game.selectNode(node);
      }
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
        inventory: {},
        resourceType: resourceType,
      );
}
