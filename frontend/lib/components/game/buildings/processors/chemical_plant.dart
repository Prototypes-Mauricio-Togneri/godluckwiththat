import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class ChemicalPlant extends Building {
  ChemicalPlant({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.chemical_plant,
        );
}
