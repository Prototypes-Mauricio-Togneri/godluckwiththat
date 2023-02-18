import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.location,
    required this.inventory,
  }) : super(type: NodeType.headquarters);

  @override
  Future onLoad() {
    game.state.resourceManager.addWarehouse(this);

    return super.onLoad();
  }

  @override
  void receive(RoutedResource routedResource) {
    if (routedResource.isDestination(this)) {
      inventory.add(routedResource.resource);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    debugText.text = inventory.toString();
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
        connections: roads.json,
      );
}
