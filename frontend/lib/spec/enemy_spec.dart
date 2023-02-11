import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class EnemySpec extends NodeSpec {
  static EnemySpec enemy1 = EnemySpec(
    type: NodeType.enemy1,
    armor: 50,
    speed: 3,
    weapon: WeaponSpec.enemy1,
  );

  static EnemySpec enemy2 = EnemySpec(
    type: NodeType.enemy2,
    armor: 70,
    speed: 4,
    weapon: WeaponSpec.enemy2,
  );

  static EnemySpec enemy3 = EnemySpec(
    type: NodeType.enemy3,
    armor: 90,
    speed: 3,
    weapon: WeaponSpec.enemy3,
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
