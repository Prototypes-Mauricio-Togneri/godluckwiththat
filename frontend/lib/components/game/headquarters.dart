import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/json/json_headquarters.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/painters/drone_painter.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';

class Headquarters extends Node {
  final DroneCounter droneCounter = DroneCounter();

  Headquarters({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(nodeType: NodeType.headquarters);

  @override
  void onMount() {
    super.onMount();

    add(droneCounter);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final int amountOfDrones = freeDrones;
    droneCounter.text = (amountOfDrones > 0) ? '$amountOfDrones' : '';

    if (game.state.constructions.isNotEmpty && hasDrones && hasConnections) {
      for (final Construction construction in game.state.constructions) {
        if (construction.enabled) {
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
  }

  bool _checkConstruction({
    required Construction construction,
    required Resource resource,
  }) {
    if (hasDrones &&
        construction.inventory.hasResource(resource) &&
        inventory.hasResource(resource)) {
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

  @override
  void droneReturned(Node from) {
    if ((from is Construction) && (from.isBuilt)) {
      removeDroneConnection(from);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final Connection connection in connections) {
      if (!connection.isVisible && !connection.isAvailable) {
        DronePainter.render(
          canvas: canvas,
          center: connection.position + (size / 2),
        );
      }
    }
  }

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );
}

class DroneCounter extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = node.size;
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(
      size: 2,
      color: Palette.error,
    );

    return super.onLoad();
  }
}
