import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class EnemySpec extends NodeSpec {
  static EnemySpec enemy = EnemySpec(
    type: NodeType.enemy,
    cost: Resources(),
    armor: 50,
    heat: 0,
    speed: 50,
    weapon: WeaponSpec.enemy,
  );

  final double speed;
  final WeaponSpec weapon;

  const EnemySpec({
    required super.type,
    required super.cost,
    required super.armor,
    required super.heat,
    required this.speed,
    required this.weapon,
  });
}
