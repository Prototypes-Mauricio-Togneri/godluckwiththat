import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  final Inventory inventory;

  Headquarters({
    required super.location,
    required this.inventory,
  }) : super(type: NodeType.headquarters);

  JsonHeadquarters get json => JsonHeadquarters(
        location: location.json,
        inventory: inventory.json,
      );
}
