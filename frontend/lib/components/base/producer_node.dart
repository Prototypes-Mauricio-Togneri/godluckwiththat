import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class ProducerNode extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  int _output = 0; // TODO(momo): receive as parameter
  final ResourceType resourceType;

  ProducerNode({
    required super.type,
    required super.location,
    required this.resourceType,
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
    } else {
      debugText.text = '';
    }
  }

  void _startProducing() {
    if (_state.isIdle && (_output < Constants.OUTPUT_QUEUE_LIMIT)) {
      _state = BuildingState.producing;
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

  // TODO(momo): call this when a robot comes back to the building
  void _sendResource() {
    // TODO(momo): implement
    /*final RoutedRobot routedRobot = game.state.resourceManager.search(
      origin: this,
      resource: resourceType,
    );

    final bool sent = send(routedRobot);

    if (sent) {
      removeRequest(routedRobot);
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
        resourceType: resourceType,
        amount: _output,
      );
      _output = 0;
      _startProducing();
    }
  }

  JsonProducer get json => JsonProducer(
        location: location.json,
        connections: [],
      );
}
