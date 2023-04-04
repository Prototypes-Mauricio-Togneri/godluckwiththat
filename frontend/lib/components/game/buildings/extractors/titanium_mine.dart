import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class TitaniumMine extends Building {
  TitaniumMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.titanium_mine,
        );
}
