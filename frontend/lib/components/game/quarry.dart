import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_quarry.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Quarry extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter

  Quarry({
    required super.type,
    required super.location,
  });

  @override
  Future onLoad() {
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
  }

  void _sendResource() {
    final RoutedResource? routedResource = game.state.resourceManager.search(
      origin: this,
      resource: ResourceType.stone,
    );

    final bool sent = send(routedResource);

    if (sent) {
      removeRequest(routedResource);
      _state = BuildingState.idle;
      _startProducing();
    }
  }

  JsonQuarry get json => JsonQuarry(
        location: location.json,
        connections: roads.json,
      );
}
