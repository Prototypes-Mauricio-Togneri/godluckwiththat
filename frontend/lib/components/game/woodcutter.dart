import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends Node {
  num _accumulatedTime = 0;
  ResourceType? _resource;

  Woodcutter({
    required super.location,
    super.roadNorth,
    super.roadEast,
    super.roadSouth,
    super.roadWest,
  }) : super(type: NodeType.woodcutter);

  @override
  void update(double dt) {
    super.update(dt);

    if (_resource == null) {
      _accumulatedTime += dt;

      if (_accumulatedTime >= type.productionTime) {
        _accumulatedTime = 0;
        _resource = ResourceType.timber;
        _sendResource();
      }
    } else {
      _sendResource();
    }

    debugText.text = '${_accumulatedTime.decimal()}';
  }

  void _sendResource() {
    if (_resource != null) {
      final Road? road = availableRoad;

      if (road != null) {
        road.send(_resource!);
        _resource = null;
      }
    }
  }

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonWoodcutter get json => JsonWoodcutter(
        location: location.json,
        resource: _resource,
      );
}
