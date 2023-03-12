import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/signs/filled_sign.dart';
import 'package:tensionplanet/components/game/signs/idle_sign.dart';
import 'package:tensionplanet/components/game/signs/unconnected_sign.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/efficiency.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/building_state.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/every.dart';

class Building extends Node {
  num accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState state = BuildingState.idle; // TODO(momo): receive as parameter
  final List<ResourceType> resourcesRequired;
  final ResourceType resourcesProduced;
  final Every every = Every(1);
  final Efficiency efficiency = Efficiency();
  IdleSign? idleSign;
  FilledSign? filledSign;
  UnconnectedSign? unconnectedSign;

  Building({
    required super.type,
    required super.location,
    required super.inventory,
    required super.connections,
    required this.resourcesRequired,
    required this.resourcesProduced,
  });

  int get outputGeneration => 1;

  double get producingProcess => accumulatedTime / type.productionTime;

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

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    every.update(dt);
    efficiency.update(this, dt);

    if (state.isWorking) {
      _produce(dt);
    }

    if ((output > 0) && hasConnections && !isDroneFactory && every.available) {
      // TODO(momo): send resource slowly by a drone
      final Resource resource = Resource.one(resourcesProduced);
      getAvailableConnection.to.receiveResource(resource);
      inventory.removeResource(resource);
      _startProducing();
    }

    if (!hasConnections && !isDroneFactory) {
      _showUnconnectedSign();
    } else {
      _hideUnconnectedSign();
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
      state = BuildingState.idle;
      _startProducing();
    }
  }

  @override
  void receiveResource(Resource resource) {
    super.receiveResource(resource);
    _startProducing();
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
        inventory: inventory.json,
      );
}
