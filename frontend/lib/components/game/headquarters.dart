import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/drone.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/drone_type.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Headquarters extends Node {
  final Inventory inventory;
  int constructionDrones = 1;

  Headquarters({
    required super.location,
    required this.inventory,
  }) : super(type: NodeType.headquarters);

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state.constructions.isNotEmpty && (constructionDrones > 0)) {
      for (final Construction construction in game.state.constructions) {
        const Resource resourceIronBlock = Resource(ResourceType.iron_block, 1);

        if ((construction.remainingIronBlock > 0) &&
            inventory.hasResource(resourceIronBlock)) {
          _sendConstructionDrone(
            construction: construction,
            resource: resourceIronBlock,
          );
        }

        if (constructionDrones == 0) {
          break;
        }
      }
    }
  }

  @override
  void receive(Drone drone) {
    if (drone.droneType == DroneType.construction) {
      constructionDrones++;
    }
  }

  void _sendConstructionDrone({
    required Construction construction,
    required Resource resource,
  }) {
    constructionDrones--;
    inventory.removeResource(resource);

    final Drone drone = Drone(
      droneType: DroneType.construction,
      resource: resource,
      origin: this,
      destinations: [construction, this],
    );
    add(drone);
    updateMenu();
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );
}
