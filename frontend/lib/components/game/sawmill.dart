import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_sawmill.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/resource_manager.dart';
import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Sawmill extends Node {
  int _timbers = 0; // TODO(momo): receive as parameter
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter

  static const int QUEUE_LIMIT = 6;

  Sawmill({
    required super.location,
  }) : super(type: NodeType.sawmill);

  @override
  Future onLoad() {
    _requestResources();
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
      _requestResources();
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
    if ((routedResource.isDestination(this)) &&
        (routedResource.has(ResourceType.timber))) {
      _timbers++;
      _startProducing();
    }
  }

  void _sendResource() {
    final List<Location> waypoints = [];
    waypoints.add(const Location(2, 0));
    waypoints.add(const Location(0, 0));

    final RoutedResource? routedResource = game.state.resourceManager.query(
      origin: this,
      resource: ResourceType.wood,
      route: Route(waypoints),
    );

    final bool sent = send(routedResource);

    if (sent) {
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  void _requestResources() {
    // TODO(momo): create variable "needs"=QUEUE_MAX and reduce it and increase it
    for (int i = _timbers; i < QUEUE_LIMIT; i++) {
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
