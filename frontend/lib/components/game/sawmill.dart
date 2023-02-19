import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_sawmill.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/resource_manager.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Sawmill extends Node {
  int _timbers = 0; // TODO(momo): receive as parameter
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter

  static const int QUEUE_LIMIT = 6;

  Sawmill({
    required super.type,
    required super.location,
  });

  @override
  Future onLoad() {
    _requestResources(QUEUE_LIMIT - _timbers);
    _startProducing();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state.isProducing) {
      _produce(dt);
    } else if (_state.isFinished) {
      _sendResource();
    }

    debugText.text =
        '${_state.name}: ${((_accumulatedTime / type.productionTime) * 100).toInt()}%';
  }

  void _startProducing() {
    if (_state.isIdle && (_timbers > 0)) {
      _timbers--;
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
          'Routed resource $routedResource arrived to sawmill $this without being the destination');
    }

    if (!routedResource.has(ResourceType.timber)) {
      throw Exception(
          'Routed resource $routedResource arrived to sawmill $this without being timber');
    }

    _timbers++;
    _startProducing();
  }

  void _sendResource() {
    final List<Location> waypoints = [];
    waypoints.add(const Location(2, 0));
    waypoints.add(const Location(0, 0));

    final RoutedResource? routedResource = game.state.resourceManager.search(
      origin: this,
      resource: ResourceType.wood,
    );

    final bool sent = send(routedResource);

    if (sent) {
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  void _requestResources(int amount) {
    for (int i = 0; i < amount; i++) {
      game.state.resourceManager.addRequest(
        ResourceRequest(
          requester: this,
          resource: ResourceType.timber,
          priority: 1,
        ),
      );
    }
  }

  JsonSawmill get json => JsonSawmill(
        location: location.json,
        connections: roads.json,
      );
}
