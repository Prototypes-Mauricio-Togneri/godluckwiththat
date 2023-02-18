import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_sawmill.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Sawmill extends Node {
  //final num _accumulatedTime = 0;
  final List<ResourceType> timbers = [];
  //ResourceType? _resource;

  Sawmill({
    required super.location,
  }) : super(type: NodeType.sawmill);

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  @override
  void receive(ResourceType resource) {
    if (resource == ResourceType.timber) {
      timbers.add(resource);
    }
  }

  JsonSawmill get json => JsonSawmill(
        location: location.json,
        connections: roads.json,
      );
}
