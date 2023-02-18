import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter

  Woodcutter({
    required super.location,
  }) : super(type: NodeType.woodcutter) {
    _startProducing();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state.isProducing) {
      _produce(dt);
    } else if (_state.isFinished) {
      _sendResource();
    }
  }

  void _startProducing() {
    if (_state.isIdle) {
      _state = BuildingState.producing;
    }
  }

  void _produce(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      _state = BuildingState.finished;
    }

    debugText.text =
        '$_state: ${((_accumulatedTime / type.productionTime) * 100).toInt()}%';
  }

  void _sendResource() {
    final RoutedResource? routedResource = game.state.resourceManager.query(
      origin: this,
      resource: ResourceType.wood,
      route: const Route([
        Location(5, 0),
        Location(2, 0),
        Location(2, -2),
      ]),
    );

    final bool sent = send(routedResource);

    if (sent) {
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  JsonWoodcutter get json => JsonWoodcutter(
        location: location.json,
        connections: roads.json,
      );
}
