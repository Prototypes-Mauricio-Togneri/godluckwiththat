import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class EnemySpec extends NodeSpec {
  static EnemySpec enemy = EnemySpec(
    type: NodeType.enemy,
    armor: 50,
    speed: 3,
    weapon: WeaponSpec.enemy,
  );

  final double speed;
  final WeaponSpec weapon;

  const EnemySpec({
    required super.type,
    required super.armor,
    required this.speed,
    required this.weapon,
  });
}
