import 'package:flame/input.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Flag extends Node {
  final Inventory inventory;

  Flag({
    required super.location,
    required this.inventory,
    super.roadNorth,
    super.roadEast,
    super.roadSouth,
    super.roadWest,
  }) : super(type: NodeType.flag);

  @override
  void receive(ResourceType resource) {
    inventory.add(resource);
  }

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonFlag get json => JsonFlag(
        location: location.json,
        inventory: inventory.json,
      );

  @override
  void update(double dt) {
    super.update(dt);

    debugText.text = inventory.toString();
  }
}
