import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends Node {
  num _accumulatedTime = 0;

  Woodcutter({
    required super.location,
    required super.resources,
  }) : super(type: NodeType.woodcutter);

  @override
  void update(double dt) {
    if (resources.isEmpty) {
      _accumulatedTime += dt;

      if (_accumulatedTime >= type.productionTime) {
        _accumulatedTime = 0;
        resources.add(ResourceType.timber);
        print(resources.toString());
      }
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonNode get json => JsonNode(
        type: type,
        location: location.json,
        resources: resources.json,
      );
}
