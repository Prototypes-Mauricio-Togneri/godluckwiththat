import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class CoalMine extends Building {
  CoalMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.coal_mine,
        );
}
