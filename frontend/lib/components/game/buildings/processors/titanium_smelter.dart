import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class TitaniumSmelter extends Building {
  TitaniumSmelter({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.titanium_smelter,
        );
}
