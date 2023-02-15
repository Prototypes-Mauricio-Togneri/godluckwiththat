import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends Node {
  num _accumulatedTime = 0;
  ResourceType? resource;

  Woodcutter({
    required super.location,
  }) : super(type: NodeType.woodcutter);

  @override
  void update(double dt) {
    if (resource == null) {
      _accumulatedTime += dt;

      if (_accumulatedTime >= type.productionTime) {
        _accumulatedTime = 0;
        resource = ResourceType.timber;
      }
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonWoodcutter get json => JsonWoodcutter(
        location: location.json,
        resource: resource,
      );
}
