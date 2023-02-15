import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/types/node_type.dart';

class Woodcutter extends Node {
  num _accumulatedTime = 0;

  Woodcutter({
    required super.location,
    required super.resources,
  }) : super(type: NodeType.woodcutter);

  @override
  void update(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
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
