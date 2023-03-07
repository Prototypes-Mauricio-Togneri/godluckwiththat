import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionnode/components/game/signs/filled_sign.dart';
import 'package:tensionnode/components/game/signs/idle_sign.dart';
import 'package:tensionnode/components/game/signs/unconnected_sign.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/every.dart';

class Building extends Node {
  num accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState state = BuildingState.idle; // TODO(momo): receive as parameter
  int output = 0; // TODO(momo): receive as parameter
  final Inventory input;
  final ResourceType resourceProduced;
  final Every every = Every(1);
  IdleSign? idleSign;
  FilledSign? filledSign;
  UnconnectedSign? unconnectedSign;

  Building({
    required super.type,
    required super.location,
    required super.drones,
    required super.droneConnections,
    required super.droneTransfers,
    required this.resourceProduced,
    required this.input,
  });

  int get outputGeneration => 1;

  @override
  Future onLoad() {
    _startProducing();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state.isWorking) {
      _produce(dt);
      debugText.text =
          '${((accumulatedTime / type.productionTime) * 100).toInt()}%';
    } else {
      debugText.text = '';
    }

    final bool isDroneFactory = this is DroneFactory;

    if ((output > 0) &&
        hasDroneConnections &&
        (hasDrones || isDroneFactory) &&
        every.update(dt)) {
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

    if (!hasDroneConnections) {
      _showUnconnectedSign();
    } else {
      _hideUnconnectedSign();
    }
  }

  bool get hasEnoughResources {
    for (final Resource resource in input.list) {
      if (resource.amount == 0) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (state.isIdle) {
      if (!hasEnoughResources) {
        _showIdleSign();
      } else if (output >= Constants.OUTPUT_QUEUE_LIMIT) {
        _showFilledSign();
      } else {
        for (final ResourceType type in input.types) {
          input.removeResource(Resource.one(type));
        }

        state = BuildingState.working;
        _removeSigns();
        updateMenu();
      }
    }
  }

  void _produce(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= type.productionTime) {
      accumulatedTime = 0;
      output += outputGeneration;
      state = BuildingState.idle;
      _startProducing();
    }
  }

  @override
  void receiveDrone(Drone drone) {
    final Resource? resource = drone.unload();

    if ((resource != null) && input.hasResourceType(resource.type)) {
      input.addResource(resource);
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
