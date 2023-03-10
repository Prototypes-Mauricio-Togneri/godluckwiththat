import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionnode/components/game/signs/filled_sign.dart';
import 'package:tensionnode/components/game/signs/idle_sign.dart';
import 'package:tensionnode/components/game/signs/unconnected_sign.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/every.dart';
import 'package:tensionnode/utils/palette.dart';

class Building extends Node {
  num accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState state = BuildingState.idle; // TODO(momo): receive as parameter
  final List<ResourceType> resourcesRequired;
  final ResourceType resourcesProduced;
  final Every every = Every(1);
  IdleSign? idleSign;
  FilledSign? filledSign;
  UnconnectedSign? unconnectedSign;
  final Paint paintProducing = Paint();

  Building({
    required super.type,
    required super.location,
    required super.inventory,
    required super.droneConnections,
    required super.droneTransfers,
    required this.resourcesRequired,
    required this.resourcesProduced,
  });

  int get outputGeneration => 1;

  int get output => inventory.get(resourcesProduced);

  List<Resource> get inputInventory =>
      inventory.list.where((e) => resourcesRequired.contains(e.type)).toList();

  List<Resource> get outputInventory =>
      inventory.list.where((e) => e.type == resourcesProduced).toList();

  List<Resource> get restInventory => inventory.list
      .where((e) =>
          (e.type != resourcesProduced) && !resourcesRequired.contains(e.type))
      .toList();

  @override
  Future onLoad() {
    _startProducing();

    paintProducing.color = Palette.error;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    every.update(dt);

    if (state.isWorking) {
      _produce(dt);
    }

    efficiencyText.text = '12%';

    final bool isDroneFactory = this is DroneFactory;

    if ((output > 0) &&
        hasDroneConnections &&
        (hasDrones || isDroneFactory) &&
        every.available) {
      if (isDroneFactory) {
        final Drone? drone = getDrone(
          home: this,
          roundtrip: false,
        );

        if (drone != null) {
          sendDrone(
            drone: drone,
            waypoints: [getAvailableConnection],
          );
        }
      } else {
        final Drone? drone = getDrone(
          home: this,
          roundtrip: true,
        );

        if (drone != null) {
          final Resource resource = Resource.one(resourcesProduced);
          drone.load(resource);
          inventory.removeResource(resource);

          sendDrone(
            drone: drone,
            waypoints: [getAvailableConnection, this],
          );
        }
      }

      _startProducing();
    }

    if (!hasDroneConnections) {
      _showUnconnectedSign();
    } else {
      _hideUnconnectedSign();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (state.isWorking) {
      canvas.drawArc(
        Rect.fromCenter(
          center: (getSize() / 2).toOffset(),
          width: size.x / 2,
          height: size.x / 2,
        ),
        0,
        (2 * pi) * (accumulatedTime / type.productionTime),
        true,
        paintProducing,
      );
    }
  }

  bool get hasEnoughResources {
    for (final ResourceType type in resourcesRequired) {
      if (inventory.get(type) == 0) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (state.isIdle) {
      if (!hasEnoughResources) {
        _showIdleSign();
      } else if (output >= game.state.research.outputQueueLimit) {
        _showFilledSign();
      } else {
        for (final ResourceType type in resourcesRequired) {
          inventory.removeResource(Resource.one(type));
        }

        state = BuildingState.working;
        _removeSigns();
      }
    }

    updateMenu();
  }

  void _produce(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= type.productionTime) {
      accumulatedTime = 0;
      inventory.addResource(Resource(resourcesProduced, outputGeneration));

      if (resourcesProduced == ResourceType.drone) {
        dronesAssigned++;
      }

      state = BuildingState.idle;
      _startProducing();
    }
  }

  @override
  void receiveDrone(Drone drone) {
    final Resource? resource = drone.unload();

    if (resource != null) {
      inventory.addResource(resource);
      _startProducing();
    }
  }

  void _showIdleSign() {
    if (idleSign == null) {
      idleSign = IdleSign();
      add(idleSign!);
    }
  }

  void _showFilledSign() {
    if (filledSign == null) {
      filledSign = FilledSign();
      add(filledSign!);
    }
  }

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

  void _removeSigns() {
    if (idleSign != null) {
      remove(idleSign!);
      idleSign = null;
    }

    if (filledSign != null) {
      remove(filledSign!);
      filledSign = null;
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
