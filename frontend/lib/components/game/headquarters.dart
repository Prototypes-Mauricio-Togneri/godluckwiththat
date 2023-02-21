import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.type,
    required super.location,
    required this.inventory,
  });

  @override
  Future onLoad() {
    game.state.resourceManager.addWarehouse(this);

    return super.onLoad();
  }

  @override
  void receive(RoutedResource routedResource) {
    if (routedResource.isDestination(this)) {
      inventory.add(routedResource.resource);
      _sendResource(routedResource.resource);
    } else {
      throw Exception(
          'Routed resource $routedResource arrived to headquarters without being the destination');
    }
  }

  /*@override
  void update(double dt) {
    super.update(dt);

    debugText.text = '${game.state.resourceManager}';
  }*/

  void _sendResource(ResourceType resourceType) {
    final RoutedResource? routedResource = game.state.resourceManager.search(
      origin: this,
      resource: resourceType,
    );

    final bool sent = send(routedResource);

    if (sent) {
      removeRequest(routedResource);
    }
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
        connections: roads.json,
      );
}
