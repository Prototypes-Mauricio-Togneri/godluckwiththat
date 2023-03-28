import 'dart:async';
import 'dart:math';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';

class Construction extends Node {
  final ResourceType? resourceType;
  final Paint paintProgress = Paint();

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
    paintProgress.color = Palette.success;

    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    game.state.headquarters.addDroneConnection(this, false);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    double received = 0;
    double total = 0;

    for (final Resource resource in nodeType.cost.resources()) {
      received += resource.amount - inventory.get(resource.resourceType);
      total += resource.amount;
    }

    canvas.drawArc(
      Rect.fromCenter(
        center: (getSize() / 2).toOffset(),
        width: size.x / 2,
        height: size.x / 2,
      ),
      -pi / 2,
      (2 * pi) * (received / total),
      true,
      paintProgress,
    );
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
