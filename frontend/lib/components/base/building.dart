import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/signs/filled_sign.dart';
import 'package:tensionplanet/components/game/signs/idle_sign.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/efficiency.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/building_state.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Building extends Node {
  num accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState state = BuildingState.idle; // TODO(momo): receive as parameter
  final ResourceMap input;
  final ResourceMap output;
  final Efficiency efficiency = Efficiency();
  IdleSign? idleSign;
  FilledSign? filledSign;

  Building({
    required super.nodeType,
    required super.location,
    required super.inventory,
    required super.connections,
  })  : input = nodeType.input,
        output = nodeType.output;

  bool get outputFilled => outputAmount >= game.state.research.outputQueueLimit;

  double get producingProcess => accumulatedTime / nodeType.productionTime;

  ResourceType get resourceProduced => output.keys.first;

  int get outputAmount => inventory.get(resourceProduced);

  bool isInInput(Resource resource) => input[resource.resourceType] != null;

  bool isInOutput(Resource resource) => output[resource.resourceType] != null;

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

    if (enabled) {
      efficiency.update(this, dt);

      if (state.isWorking) {
        _produce(dt);
      }

      if ((outputAmount > 0) && hasConnections) {
        final Connection? connection = nextAvailableConnection;

        if (connection != null) {
          final Resource resource = Resource.one(resourceProduced);
          final Node target = connection.to;
          final bool canReceive = target.isHeadquarters ||
              target.isWarehouse ||
              (target.isBuilding &&
                  (target as Building).canReceiveResource(resource));

          if (canReceive) {
            connection.send(resource);
            inventory.removeResource(resource);
            _startProducing();
          }
        }
      }
    }
  }

  bool canReceiveFrom(ResourceType resourceType) =>
      input.keys.contains(resourceType);

  bool canReceiveResource(Resource resource) =>
      inventory.get(resource.resourceType) <
      game.state.research.inputQueueLimit;

  bool _hasEnoughResources() {
    for (final ResourceType resourceType in input.keys) {
      if (inventory.get(resourceType) < input[resourceType]!) {
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
        for (final ResourceType resourceType in input.keys) {
          inventory
              .removeResource(Resource(resourceType, input[resourceType]!));
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

    if (accumulatedTime >= nodeType.productionTime) {
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
        resourceType: null,
      );
}
