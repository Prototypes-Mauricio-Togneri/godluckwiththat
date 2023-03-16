import 'package:flame/components.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';

class Warehouse extends Node {
  final ResourceType resourceType;

  Warehouse({
    required super.location,
    required super.inventory,
    required super.connections,
    required this.resourceType,
  }) : super(nodeType: NodeType.warehouse);

  @override
  Future onLoad() async {
    add(ResourceBackground());
    add(ResourceIcon(resourceType));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (enabled) {
      if ((inventory.get(resourceType) > 0) && hasConnections) {
        final Connection? connection = nextAvailableConnection;

        if (connection != null) {
          final Resource resource = Resource.one(resourceType);
          final Node target = connection.to;
          final bool canReceive = target.isHeadquarters ||
              target.isWarehouse ||
              (target.isBuilding &&
                  (target as Building).canReceiveResource(resource));

          if (canReceive) {
            connection.send(resource);
            inventory.removeResource(resource);
          }
        }
      }
    }
  }

  bool canReceiveFrom(ResourceType resourceType) =>
      resourceType == this.resourceType;

  JsonBuilding get json => JsonBuilding(
        location: location.json,
        inventory: inventory.json,
        resourceType: resourceType,
      );
}

class ResourceIcon extends SpriteComponent {
  final ResourceType resourceType;

  ResourceIcon(this.resourceType);

  @override
  Future onLoad() async {
    sprite = await getSprite(resourceType.sprite);
    size = getSize();
    anchor = Anchor.center;
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    return super.onLoad();
  }
}

class ResourceBackground extends SpriteComponent {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_BUILDINGS_OTHER_VOID_BACKGROUND);
    size = getSize();
    anchor = Anchor.center;
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    return super.onLoad();
  }
}
