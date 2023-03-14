import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class StoneMine extends Building {
  StoneMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.stone_mine,
        );
}
