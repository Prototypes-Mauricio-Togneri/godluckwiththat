import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/resource_map_extension.dart';
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
          inventory: nodeType.cost.asInventory,
          connections: [],
        );

  bool get isBuilt => inventory.isEmpty;

  @override
  Future onLoad() {
    opacity = 0.5;

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

    for (final Resource resource in nodeType.cost.resources()) {
      received += resource.amount - inventory.get(resource.resourceType);
      total += resource.amount;
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

    if (isBuilt) {
      destroy(
        sendDronesBack: false,
        resourcesBack: Inventory.empty(),
      );
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
