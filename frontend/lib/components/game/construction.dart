import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';

class Construction extends Node {
  final ResourceType? resourceType;
  final DebugText debugText = DebugText();

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

    for (final MapEntry<ResourceType, int> entry in nodeType.cost.entries) {
      final Resource resource = Resource(
        entry.key,
        entry.value,
      );

      inventory.addResource(resource);
    }

    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    add(debugText);
    game.state.headquarters.addDroneConnection(this, false);
  }

  @override
  void update(double dt) {
    super.update(dt);

    double received = 0;
    double total = 0;

    for (final MapEntry<ResourceType, int> entry in nodeType.cost.entries) {
      received += entry.value - inventory.get(entry.key);
      total += entry.value;
    }

    debugText.text = '${((received / total) * 100).toInt()}%';
  }

  @override
  void receiveResource(Resource resource) {
    inventory.removeResource(Resource(
      resource.resourceType,
      resource.amount,
    ));
    updateMenu();

    if (inventory.isEmpty) {
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

class DebugText extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = node.size / 2;
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(
      size: 2,
      color: Palette.error,
    );

    return super.onLoad();
  }
}
