import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_transformer.dart';
import 'package:tensionnode/models/routed_robot.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class TransformerNode extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  final Map<ResourceType, int> _input =
      {}; // TODO(momo): receive as parameter
  int _output = 0;
  final ResourceType resourceProduced;

  TransformerNode({
    required super.type,
    required super.location,
    required this.resourceProduced,
    required Resources resourcesRequired,
  }) {
    for (final ResourceType resource in resourcesRequired) {
      _input[resource] = 0;
    }
  }

  Map<ResourceType, int> get resourcesRequired => _input;

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
      for (final int amount in _input.values) {
        if (amount == 0) {
          return false;
        }
      }
    }

    return true;
  }

  void _startProducing() {
    if (_state.isIdle && _hasEnoughResources && (_output < Constants.OUTPUT_QUEUE_LIMIT)) {
      for (final ResourceType key in _input.keys) {
        _input[key] = _input[key]! - 1;
      }

      _state = BuildingState.working;
    }
  }

  void _produce(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      _output++;
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
  void specialSelect() {
    if (_output > 0) {
      game.state.addToInventory(
        resourceType: resourceProduced,
        amount: _output,
      );
      _output = 0;
      _startProducing();
    }
  }

  JsonTransformer get json => JsonTransformer(
        location: location.json,
        connections: [],
      );
}
