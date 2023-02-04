import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class MineSpec extends FixedNodeSpec {
  final int productionTime;
  final ResourceType resource;

  static MineSpec mine_red = MineSpec(
    type: NodeType.mine_red,
    cost: Resources(red: 10, green: 0, blue: 0),
    armor: 20,
    heat: 1,
    productionTime: 1,
    resource: ResourceType.red,
  );

  static MineSpec mine_green = MineSpec(
    type: NodeType.mine_green,
    cost: Resources(red: 20, green: 0, blue: 0),
    armor: 20,
    heat: 2,
    productionTime: 2,
    resource: ResourceType.green,
  );

  static MineSpec mine_blue = MineSpec(
    type: NodeType.mine_blue,
    cost: Resources(red: 30, green: 0, blue: 0),
    armor: 20,
    heat: 3,
    productionTime: 3,
    resource: ResourceType.blue,
  );

  const MineSpec({
    required super.type,
    required super.cost,
    required super.armor,
    required super.heat,
    required this.productionTime,
    required this.resource,
  });
}
