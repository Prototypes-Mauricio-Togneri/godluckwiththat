import 'package:tensionnode/types/node_type.dart';

enum BuildType {
  mine(NodeType.mine),
  power_plant(NodeType.power_plant),
  defense(null);

  final NodeType? nodeType;

  const BuildType(this.nodeType);
}
