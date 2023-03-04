import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/building_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Building extends Node {
  num _accumulatedTime = 0; // TODO(momo): receive as parameter
  BuildingState _state = BuildingState.idle; // TODO(momo): receive as parameter
  int _output = 0; // TODO(momo): receive as parameter
  final Inventory input;
  final ResourceType resourceProduced;

  Building({
    required super.type,
    required super.location,
    required this.resourceProduced,
    required this.input,
    super.constructionDrones,
    super.logisticDrones,
  });

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
    for (final Resource resource in input.list) {
      if (resource.amount == 0) {
        return false;
      }
    }

    return true;
  }

  void _startProducing() {
    if (_state.isIdle &&
        _hasEnoughResources &&
        (_output < Constants.OUTPUT_QUEUE_LIMIT)) {
      for (final ResourceType type in input.types) {
        input.removeResource(Resource(type, 1));
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
      _startProducing();
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
