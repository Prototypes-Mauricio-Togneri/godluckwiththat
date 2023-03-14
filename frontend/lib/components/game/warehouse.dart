import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/signs/unconnected_sign.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/every.dart';

class Warehouse extends Node {
  final ResourceType resourceType;
  final Every every = Every(1);
  UnconnectedSign? unconnectedSign;

  Warehouse({
    required super.location,
    required super.inventory,
    required super.connections,
    required this.resourceType,
  }) : super(nodeType: NodeType.warehouse);

  @override
  void update(double dt) {
    super.update(dt);
    every.update(dt);

    if ((inventory.get(resourceType) > 0) &&
        hasConnections &&
        every.available) {
      // TODO(momo): send resource slowly by a drone
      final Node target = getAvailableConnection.to;
      final Resource resource = Resource.one(resourceType);
      final bool canReceive = target.isHeadquarters ||
          target.isWarehouse ||
          (target.isBuilding &&
              (target as Building).canReceiveResource(resource));

      if (canReceive) {
        target.receiveResource(resource);
        inventory.removeResource(resource);
      }
    }

    if (!hasConnections) {
      _showUnconnectedSign();
    } else {
      _hideUnconnectedSign();
    }
  }

  bool canReceiveFrom(ResourceType resourceType) =>
      resourceType == this.resourceType;

  void _showUnconnectedSign() {
    if (unconnectedSign == null) {
      unconnectedSign = UnconnectedSign();
      add(unconnectedSign!);
    }
  }

  void _hideUnconnectedSign() {
    if (unconnectedSign != null) {
      remove(unconnectedSign!);
      unconnectedSign = null;
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
        inventory: inventory.json,
        resourceType: resourceType,
      );
}
