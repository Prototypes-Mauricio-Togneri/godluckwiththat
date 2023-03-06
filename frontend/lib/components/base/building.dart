import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/palette.dart';

class Building extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  int output = 0; // TODO(momo): receive as parameter
  final Inventory input;
  final ResourceType resourceProduced;
  final Paint _paintOutside = Paint();
  final Paint _paintInside = Paint();

  Building({
    required super.type,
    required super.location,
    required super.drones,
    required super.droneConnections,
    required super.droneTransfers,
    required this.resourceProduced,
    required this.input,
  });

  @override
  Future onLoad() {
    _paintOutside.color = Palette.error;
    _paintOutside.strokeWidth = 4 / Constants.NODE_SIZE;
    _paintOutside.style = PaintingStyle.stroke;

    _paintInside.color = Palette.white;
    _paintInside.strokeWidth = 2 / Constants.NODE_SIZE;
    _paintInside.style = PaintingStyle.stroke;

    _startProducing();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state.isWorking) {
      _produce(dt);
      debugText.text =
          '${((_accumulatedTime / type.productionTime) * 100).toInt()}%';
    } else {
      debugText.text = '';
    }

    final bool isDroneFactory = this is DroneFactory;

    if ((output > 0) && hasDroneConnections && (hasDrones || isDroneFactory)) {
      output--;

      if (isDroneFactory) {
        final Drone drone = Drone();
        sendDrone(
          drone: drone,
          waypoints: [getAvailableConnection],
        );
      } else {
        final Drone drone = getDrone();
        drone.load(Resource.one(resourceProduced));
        sendDrone(
          drone: drone,
          waypoints: [getAvailableConnection, this],
        );
      }
      _startProducing();
    }
  }

  bool get _hasEnoughResources {
    for (final Resource resource in input.list) {
      if (resource.amount == 0) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (_state.isIdle &&
        _hasEnoughResources &&
        (output < Constants.OUTPUT_QUEUE_LIMIT)) {
      for (final ResourceType type in input.types) {
        input.removeResource(Resource.one(type));
      }

      _state = BuildingState.working;
    }

    updateMenu();
  }

  void _produce(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      output += outputGeneration;
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  int get outputGeneration => 1;

  @override
  void receiveDrone(Drone drone) {
    final Resource? resource = drone.unload();

    if ((resource != null) && input.hasResourceType(resource.type)) {
      input.addResource(resource);
      _startProducing();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!hasDroneConnections) {
      canvas.drawRect(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: width,
          height: height,
        ),
        _paintOutside,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: width * 0.98,
          height: height * 0.98,
        ),
        _paintInside,
      );
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
