import 'package:flame/events.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.location,
    required this.inventory,
    super.roadNorth,
    super.roadEast,
    super.roadSouth,
    super.roadWest,
  }) : super(type: NodeType.headquarters);

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );

  @override
  void update(double dt) {
    super.update(dt);

    debugText.text = inventory.toString();
  }
}
