import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_mill.dart';
import 'package:tensionnode/models/resource_manager.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mill extends Node {
  int _grains = 0; // TODO(momo): receive as parameter
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter

  Mill({
    required super.type,
    required super.location,
  });

  @override
  Future onLoad() {
    _requestResources(Constants.TRANSFORMER_RESOURCE_QUEUE_LIMIT - _grains);
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
      debugText.text = 'finished';
    } else if (_state.isIdle) {
      debugText.text = 'idle';
    }
  }

  void _startProducing() {
    if (_state.isIdle && (_grains > 0)) {
      _grains--;
      _state = BuildingState.producing;
      _requestResources(1);
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
          'Routed resource $routedResource arrived to mill $this without being the destination');
    }

    if (!routedResource.has(ResourceType.grain)) {
      throw Exception(
          'Routed resource $routedResource arrived to mill $this without being grain');
    }

    _grains++;
    _startProducing();
  }

  void _sendResource() {
    final RoutedResource? routedResource = game.state.resourceManager.search(
      origin: this,
      resource: ResourceType.flour,
    );

    final bool sent = send(routedResource);

    if (sent) {
      removeRequest(routedResource);
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  void _requestResources(int amount) {
    for (int i = 0; i < amount; i++) {
      game.state.resourceManager.addRequest(
        ResourceRequest(
          requester: this,
          resource: ResourceType.grain,
          priority: 1,
        ),
      );
    }
  }

  JsonMill get json => JsonMill(
        location: location.json,
        connections: roads.json,
      );
}
