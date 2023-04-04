import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class StoneSmelter extends Building {
  StoneSmelter({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.stone_smelter,
        );
}
