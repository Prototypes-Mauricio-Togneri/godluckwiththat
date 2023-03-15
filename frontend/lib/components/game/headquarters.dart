import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/json/json_headquarters.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Headquarters extends Node {
  Headquarters({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(nodeType: NodeType.headquarters);

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state.constructions.isNotEmpty && hasDrones && hasConnections) {
      for (final Construction construction in game.state.constructions) {
        final bool ironSent = _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.iron_block),
        );

        if (ironSent) {
          break;
        }

        final bool copperSent = _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.copper_block),
        );

        if (copperSent) {
          break;
        }

        final bool steelSent = _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.steel),
        );

        if (steelSent) {
          break;
        }

        final bool concreteSent = _checkConstruction(
          construction: construction,
          resource: Resource.one(ResourceType.concrete),
        );

        if (concreteSent) {
          break;
        }
      }
    }
  }

  bool _checkConstruction({
    required Construction construction,
    required Resource resource,
  }) {
    if (hasDrones && inventory.hasResource(resource)) {
      return _sendConstructionDrone(
        construction: construction,
        resource: resource,
      );
    } else {
      return false;
    }
  }

  bool _sendConstructionDrone({
    required Construction construction,
    required Resource resource,
  }) {
    final Connection? connection = nextAvailableConnection;

    if (connection != null) {
      inventory.removeResource(resource);
      connection.send(resource);
      updateMenu();
    }

    return connection != null;
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );
}
