import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class TurretSpec extends FixedNodeSpec {
  final WeaponSpec weapon;

  static TurretSpec turret_light = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 1,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 30, green: 0, blue: 0),
  );

  static TurretSpec turret_heavy = TurretSpec(
    type: NodeType.turret_heavy,
    armor: 60,
    heat: 2,
    weapon: WeaponSpec.turret_heavy,
    cost: Resources(red: 20, green: 10, blue: 0),
  );

  static TurretSpec turret_machine_gun = TurretSpec(
    type: NodeType.turret_machine_gun,
    armor: 80,
    heat: 2,
    weapon: WeaponSpec.turret_machine_gun,
    cost: Resources(red: 40, green: 20, blue: 10),
  );

  const TurretSpec({
    required super.type,
    required super.cost,
    required super.armor,
    required super.heat,
    required this.weapon,
  });
}
