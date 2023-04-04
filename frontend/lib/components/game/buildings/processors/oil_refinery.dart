import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class OilRefinery extends Building {
  OilRefinery({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.oil_refinery,
        );
}
