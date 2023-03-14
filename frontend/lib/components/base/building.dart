import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/signs/filled_sign.dart';
import 'package:tensionplanet/components/game/signs/idle_sign.dart';
import 'package:tensionplanet/components/game/signs/unconnected_sign.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/efficiency.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/building_state.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/every.dart';

class Building extends Node {
  num accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState state = BuildingState.idle; // TODO(momo): receive as parameter
  final ResourceMap input;
  final ResourceMap output;
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
  })  : input = type.input,
        output = type.output;

  bool get outputFilled => outputAmount >= game.state.research.outputQueueLimit;

  double get producingProcess => accumulatedTime / type.productionTime;

  ResourceType get resourceProduced => output.keys.first;

  int get outputAmount => inventory.get(resourceProduced);

  bool isInInput(Resource resource) => input[resource.type] != null;

  bool isInOutput(Resource resource) => output[resource.type] != null;

  List<Resource> get inputInventory => inventory.list.where(isInInput).toList();

  List<Resource> get outputInventory =>
      inventory.list.where(isInOutput).toList();

  List<Resource> get restInventory =>
      inventory.list.where((e) => !isInInput(e) && !isInOutput(e)).toList();

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

    if ((outputAmount > 0) && hasConnections && every.available) {
      // TODO(momo): send resource slowly by a drone
      final Node target = getAvailableConnection.to;
      final Resource resource = Resource.one(resourceProduced);
      final bool canReceive = target.isHeadquarters ||
          target.isWarehouse ||
          (target.isBuilding &&
              (target as Building).canReceiveResource(resource));

      if (canReceive) {
        target.receiveResource(resource);
        inventory.removeResource(resource);
        _startProducing();
      }
    }

    if (!hasConnections && !isDroneFactory) {
      _showUnconnectedSign();
    } else {
      _hideUnconnectedSign();
    }
  }

  bool canReceiveFrom(ResourceType type) => input.keys.contains(type);

  bool canReceiveResource(Resource resource) =>
      inventory.get(resource.type) < game.state.research.inputQueueLimit;

  bool _hasEnoughResources() {
    for (final ResourceType type in input.keys) {
      if (inventory.get(type) < input[type]!) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (state.isIdle) {
      if (!_hasEnoughResources()) {
        _showIdleSign();
      } else if (outputFilled) {
        _showFilledSign();
      } else {
        for (final ResourceType type in input.keys) {
          inventory.removeResource(Resource(type, input[type]!));
        }

        state = BuildingState.working;
        _removeSigns();
      }
    }

    updateMenu();
  }

  void _produce(double dt) {
    accumulatedTime += dt;
    updateMenu();

    if (accumulatedTime >= type.productionTime) {
      accumulatedTime = 0;
      final Resource resource =
          Resource(resourceProduced, output[resourceProduced]!);
      inventory.addResource(resource);
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
