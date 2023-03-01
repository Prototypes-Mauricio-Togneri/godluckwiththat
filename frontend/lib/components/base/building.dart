import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/models/routed_robot.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Building extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  int _output = 0; // TODO(momo): receive as parameter
  final Inventory _input = Inventory();
  final ResourceType resourceProduced;

  Building({
    required super.type,
    required super.location,
    required this.resourceProduced,
    required ResourceMap resourcesRequired,
  }) {
    for (final MapEntry<ResourceType, int> entry in resourcesRequired.entries) {
      _input.addResource(Resource(entry.key, entry.value));
    }
  }

  Inventory get resourcesRequired => _input;

  int get output => _output;

  @override
  Future onLoad() {
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
  }

  bool get _hasEnoughResources {
    if (_input.isNotEmpty) {
      for (final Resource resource in _input.list) {
        if (resource.amount == 0) {
          return false;
        }
      }
    }

    return true;
  }

  void _startProducing() {
    if (_state.isIdle &&
        _hasEnoughResources &&
        (_output < Constants.OUTPUT_QUEUE_LIMIT)) {
      for (final ResourceType type in _input.types) {
        _input.removeResource(Resource(type, 1));
      }

      _state = BuildingState.working;
    }
  }

  void _produce(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      _output++;
      updateMenu();
      _state = BuildingState.idle;
      _sendResource();
      _startProducing();
    }
  }

  @override
  void receive(RoutedRobot routedRobot) {
    /*if (!routedRobot.isDestination(this)) {
      throw Exception(
          'Routed resource $routedRobot arrived to $runtimeType $this without being the destination');
    }

    bool resourceFound = false;

    for (final ResourceType key in _resourcesRequired.keys) {
      if (routedRobot.has(key)) {
        _resourcesRequired[key] = _resourcesRequired[key]! + 1;
        resourceFound = true;
      }
    }

    if (!resourceFound) {
      throw Exception(
          'Routed resource $routedRobot arrived to $runtimeType $this without being flour or water');
    }*/

    _startProducing();
  }

  void _sendResource() {
    /*final RoutedRobot routedResource = game.state.resourceManager.search(
      origin: this,
      resource: resourceProduced,
    );

    final bool sent = send(routedResource);

    removeComponents(WarningSign);

    if (sent) {
      removeRequest(routedResource);
      _state = BuildingState.idle;
      _startProducing();
    } else {
      add(WarningSign());
    }*/
  }

  @override
  void moveResourcesToInventory() {
    if (_output > 0) {
      game.state.addToInventory(Resource(
        resourceProduced,
        _output,
      ));

      _output = 0;
      updateMenu();
      _startProducing();
    }
  }

  @override
  void moveResourcesFromInventory() {
    final Inventory map = game.state.removeFromInventory(_input);

    if (map.isNotEmpty) {
      for (final ResourceType type in map.types) {
        _input.addResource(Resource(type, map.get(type)));
      }

      updateMenu();
      _startProducing();
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
        connections: [],
      );
}
