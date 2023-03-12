import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class IronMine extends Building {
  IronMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.iron_mine,
        );
}
