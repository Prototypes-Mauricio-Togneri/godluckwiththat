import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/weapon_type.dart';

class EnemySpec extends NodeSpec {
  static EnemySpec enemy = EnemySpec(
    type: NodeType.enemy,
    cost: Resources(),
    armor: 50,
    speed: 50,
    weapon: WeaponType.enemy,
  );

  final double speed;
  final WeaponType weapon;

  const EnemySpec({
    required super.type,
    required super.cost,
    required super.armor,
    required this.speed,
    required this.weapon,
  });
}
