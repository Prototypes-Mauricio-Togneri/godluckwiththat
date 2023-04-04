import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class PolymerPlant extends Building {
  PolymerPlant({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.polymer_plant,
        );
}
