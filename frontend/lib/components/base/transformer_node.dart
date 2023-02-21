import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/idle_sign.dart';
import 'package:tensionnode/components/game/warning_sign.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/json/json_transformer.dart';
import 'package:tensionnode/models/resource_manager.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class TransformerNode extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  final Map<ResourceType, int> _resourcesRequired =
      {}; // TODO(momo): receive as parameter
  final ResourceType resourceProduced;

  TransformerNode({
    required super.type,
    required super.location,
    required this.resourceProduced,
    required List<ResourceType> resourcesRequired,
  }) {
    for (final ResourceType resource in resourcesRequired) {
      _resourcesRequired[resource] = 0;
    }
  }

  Map<ResourceType, int> get resourcesRequired => _resourcesRequired;

  @override
  Future onLoad() {
    for (final MapEntry<ResourceType, int> entry
        in _resourcesRequired.entries) {
      _requestResources(
        Constants.TRANSFORMER_RESOURCE_QUEUE_LIMIT - entry.value,
        entry.key,
      );
    }
    _startProducing();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state.isProducing) {
      _produce(dt);
      debugText.text =
          '${((_accumulatedTime / type.productionTime) * 100).toInt()}%';
    } else if (_state.isFinished) {
      _sendResource();
      debugText.text = '';
    }
  }

  bool get _hasEnoughResources {
    for (final int amount in _resourcesRequired.values) {
      if (amount == 0) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (_state.isIdle && _hasEnoughResources) {
      for (final ResourceType key in _resourcesRequired.keys) {
        _resourcesRequired[key] = _resourcesRequired[key]! - 1;
        _requestResources(1, key);
      }

      _state = BuildingState.producing;
      removeComponents(IdleSign);
    } else {
      removeComponents(IdleSign);
      add(IdleSign());
    }
  }

  void _produce(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      _state = BuildingState.finished;
    }
  }

  @override
  void receive(RoutedResource routedResource) {
    if (!routedResource.isDestination(this)) {
      throw Exception(
          'Routed resource $routedResource arrived to $runtimeType $this without being the destination');
    }

    bool resourceFound = false;

    for (final ResourceType key in _resourcesRequired.keys) {
      if (routedResource.has(key)) {
        _resourcesRequired[key] = _resourcesRequired[key]! + 1;
        resourceFound = true;
      }
    }

    if (!resourceFound) {
      throw Exception(
          'Routed resource $routedResource arrived to $runtimeType $this without being flour or water');
    }

    _startProducing();
  }

  void _sendResource() {
    final RoutedResource? routedResource = game.state.resourceManager.search(
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
    }
  }

  void _requestResources(int amount, ResourceType resource) {
    for (int i = 0; i < amount; i++) {
      game.state.resourceManager.addRequest(
        ResourceRequest(
          requester: this,
          resource: resource,
          priority: 1,
        ),
      );
    }
  }

  JsonTransformer get json => JsonTransformer(
        location: location.json,
        connections: roads.json,
      );
}
