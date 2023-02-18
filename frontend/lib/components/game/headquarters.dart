import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource_manager.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.location,
    required this.inventory,
  }) : super(type: NodeType.headquarters);

  @override
  Future onLoad() {
    _requestResources();

    return super.onLoad();
  }

  @override
  void receive(RoutedResource routedResource) {
    if (routedResource.isDestination(this)) {
      inventory.add(routedResource.resource);
    }
  }

  void _requestResources() {
    // TODO(momo): create variable "needs"=QUEUE_MAX and reduce it and increase it
    for (int i = 0; i < 5; i++) {
      game.state.resourceManager.addRequest(
        ResourceRequest(
          requester: this,
          resource: ResourceType.wood,
          priority: 1,
        ),
      );
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
